//
//  SuperpoweredWrapped.h
//  SongCrypt
//
//  Created by Ryan Sullivan on 1/21/17.
//  Copyright © 2017 Ryan Sullivan. All rights reserved.
//

#ifndef SuperpoweredWrapped_h
#define SuperpoweredWrapped_h

@interface Superpowered: NSObject{
@public
    bool playing;
    uint64_t avgUnitsPerSecond, maxUnitsPerSecond;
}
-(id)init;
-(void)togglePlayback;
-(void)toggle;
@end

#endif /* SuperpoweredWrapped_h */
