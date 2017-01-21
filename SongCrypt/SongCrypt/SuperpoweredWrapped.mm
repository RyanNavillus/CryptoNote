//
//  Superpowered.m
//  SongCrypt
//
//  Created by Ryan Sullivan on 1/21/17.
//  Copyright © 2017 Ryan Sullivan. All rights reserved.
//
#import "SuperpoweredSimple.h"
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredWrapped.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredFX.h"
#import "SuperpoweredReverb.h"
#import "SuperpoweredFilter.h"
#import "Superpowered3BandEQ.h"
#import "SuperpoweredEcho.h"
#import "SuperpoweredRoll.h"
#import "SuperpoweredFlanger.h"
#import <mach/mach_time.h>
#import <Foundation/Foundation.h>

@implementation Superpowered  {
    SuperpoweredAdvancedAudioPlayer *player;
    SuperpoweredIOSAudioIO *audioIO;
    SuperpoweredFX *effects[NUMFXUNITS];
    float *stereoBuffer;
    bool started;
    uint64_t timeUnitsProcessed, maxTime;
    unsigned int lastPositionSeconds, lastSamplerate, samplesProcessed;
}

- (bool)toggleFx:(int)index {
    if (index == TIMEPITCHINDEX) {
        bool enabled = (player->tempo != 1.0f);
        player->setTempo(enabled ? 1.0f : 1.1f, true);
        return !enabled;
    } else if (index == PITCHSHIFTINDEX) {
        bool enabled = (player->pitchShift != 0);
        player->setPitchShift(enabled ? 0 : 1);
        return !enabled;
    } else {
        bool enabled = effects[index]->enabled;
        effects[index]->enable(!enabled);
        return !enabled;
    };
}

- (void)togglePlayback { // Play/pause.
    player->togglePlayback();
    if(player->playing == YES)
    {
        NSLog(@"Playing\n");

    } else {
        NSLog(@"Not playing\n");

    }
}

- (void)seekTo:(float)percent {
    player->seek(percent);
}

- (void)toggle {
    if (started) [audioIO stop]; else [audioIO start];
    started = !started;
}

- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}

- (void)interruptionEnded {
    player->onMediaserverInterrupt(); // If the player plays Apple Lossless audio files, then we need this. Otherwise unnecessary.
}


// This is where the Superpowered magic happens.
static bool audioProcessing(void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    __unsafe_unretained Superpowered *self = (__bridge Superpowered *)clientdata;
    uint64_t startTime = mach_absolute_time();
    
    if (samplerate != self->lastSamplerate) { // Has samplerate changed?
        self->lastSamplerate = samplerate;
        self->player->setSamplerate(samplerate);
        for (int n = 2; n < NUMFXUNITS; n++) self->effects[n]->setSamplerate(samplerate);
    };
    
    // We're keeping our Superpowered time-based effects in sync with the player... with one line of code. Not bad, eh?
    ((SuperpoweredRoll *)self->effects[ROLLINDEX])->bpm = ((SuperpoweredFlanger *)self->effects[FLANGERINDEX])->bpm = ((SuperpoweredEcho *)self->effects[DELAYINDEX])->bpm = self->player->currentBpm;
    
    /*
     Let's process some audio.
     If you'd like to change connections or tap into something, no abstract connection handling and no callbacks required!
     */
    bool silence = !self->player->process(self->stereoBuffer, false, numberOfSamples, 1.0f, 0.0f, -1.0);
    if (self->effects[ROLLINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples)) silence = false;
    self->effects[FILTERINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[EQINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[FLANGERINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    if (self->effects[DELAYINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples)) silence = false;
    if (self->effects[REVERBINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples)) silence = false;
    
    // CPU measurement code to show some nice numbers for the business guys.
    /*uint64_t elapsedUnits = mach_absolute_time() - startTime;
    if (elapsedUnits > self->maxTime) self->maxTime = elapsedUnits;
    self->timeUnitsProcessed += elapsedUnits;
    self->samplesProcessed += numberOfSamples;
    if (self->samplesProcessed >= samplerate) {
        self->avgUnitsPerSecond = self->timeUnitsProcessed;
        self->maxUnitsPerSecond = (double(samplerate) / double(numberOfSamples)) * self->maxTime;
        self->samplesProcessed = self->timeUnitsProcessed = self->maxTime = 0;
    };*/
    
    self->playing = self->player->playing;
    if (!silence) SuperpoweredDeInterleave(self->stereoBuffer, buffers[0], buffers[1], numberOfSamples); // The stereoBuffer is ready now, let's put the finished audio into the requested buffers.
    return !silence;
}


-(id)init {
    self = [super init];
    if (!self) return nil;
    started = false;
    player = new SuperpoweredAdvancedAudioPlayer(NULL, NULL, 44100, 0);
    player->open([[[NSBundle mainBundle] pathForResource:@"track" ofType:@"mp3"] fileSystemRepresentation]);
    player->play(false);
    player->setBpm(124.0f);
    
    audioIO = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayback channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
    //[audioIO start];
    return self;
}

@end
