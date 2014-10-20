//
//  PDQueue.h
//  PipeDream
//
//  Created by Dominik Krejčík on 25/09/2011. Originally named DKQueue.
//  Obtained from https://github.com/dominikkrejcik/Objective-C-Stack---Queue
//  Lisceencing information:
//  "Feel free to use and distribute as long as you mention me. Or buy me a beer."

// PDQueue - FIFO (first in first out) data structure for Objective-C

#import <Foundation/Foundation.h>

@interface PDQueue : NSObject {
    NSMutableArray* array;
}

// Removes and returns the element at the front of the queue
-(id)dequeue;
// Add the element to the back of the queue
-(void)enqueue:(id)element;
// Remove all elements
-(void)enqueueElementsFromArray:(NSArray*)arr;
-(void)enqueueElementsFromQueue:(PDQueue*)queue;
-(void)clear;

// Returns the element at the front of the queue
-(id)peek;
// Returns YES if the queue is empty
-(BOOL)isEmpty;
// Returns the size of the queue
-(NSInteger)size;

@end