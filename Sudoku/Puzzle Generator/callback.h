//
//  callback.h
//  Sudoku
//
//  Created by Amanda Rawls on 11/28/17.
//  Copyright © 2017 Amanda Rawls. All rights reserved.
//
/*
 I noticed the generator was always returning the same puzzle,
 in the C program, random() is called. When I jump to that definition I see:
 long     random(void) __swift_unavailable("Use arc4random instead.");
 
 In searching this function, it appears to be a Swift function unavailable in C. So I need to
 call a swift function that will return a random value so my generator will work.
 
 I am using this stack overflow OP's solution, as no one provided them with a better method
 and I didn't find a different solution elsewhere.
 https://stackoverflow.com/questions/35106118/what-is-the-best-way-to-call-into-swift-from-c
 */


#ifndef callback_h
#define callback_h


typedef int (*swiftFuncPtr)(void);

#endif /* callback_h */
