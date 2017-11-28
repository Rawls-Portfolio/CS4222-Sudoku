//
//  callback.h
//  Sudoku
//
//  Created by Amanda Rawls on 11/28/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//
/*
 I noticed the generator was always returning the same puzzle,
 in the pick_value function, random() is called. When I jump to that definition I see:
 long     random(void) __swift_unavailable("Use arc4random instead.");
 
 In searching this function, it appears to be a Swift function unavailable in C. So I need to
 call a swift function that will return a random value so my generator will work.
 
 I am using this stack overflow for my first attempt to solve this problem. The OP's solution is used.
 https://stackoverflow.com/questions/35106118/what-is-the-best-way-to-call-into-swift-from-c
 
 https://oleb.net/blog/2015/06/c-callbacks-in-swift/
 */


#ifndef callback_h
#define callback_h


typedef void (*callback_t)(void);
void callBackIntoSwift( callback_t cb );

#endif /* callback_h */
