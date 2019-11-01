//
//  ViewController.m
//  test
//
//  Created by old's mac on 2017/6/28.
//  Copyright © 2017年 gzlc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Create Random Array
- (NSArray *)createRandomArrayWithCount:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        int value = (arc4random() % 20) + 1;
        [array addObject:@(value)];
    }
    return array;
}

#pragma mark - Print Tree
- (void)printTree:(NSArray *)tree {
    int treeLength = ceil(log2(tree.count + 1));
    int lastNodeIndex = 0;
    int currentNode = 0;
    int maxNodeNumber = pow(2, treeLength - 1);
    NSMutableString *currentNodeStr = [NSMutableString string];
    NSMutableArray *currenLevelNodeArray = [NSMutableArray array];
    for (int i = 0; i < tree.count; i++) {
        [currenLevelNodeArray addObject:tree[i]];
        if (i == lastNodeIndex && currentNode < treeLength) {
            int perLineSpaceCharCount = 3 * maxNodeNumber / (currenLevelNodeArray.count + 1);
            NSMutableString *spaceCharStr = [NSMutableString string];
            for (int idx = 0; idx < perLineSpaceCharCount; idx++) {
                [spaceCharStr appendString:@" "];
            }
            [currentNodeStr appendString:spaceCharStr];
            for (int d = 0; d < currenLevelNodeArray.count; d++) {
                [currentNodeStr appendFormat:@"%@%@", currenLevelNodeArray[d], spaceCharStr];
            }
            NSLog(@"%@", currentNodeStr);
            currentNodeStr = [NSMutableString string];
            [currenLevelNodeArray removeAllObjects];
            lastNodeIndex = lastNodeIndex * 2 + 2;
            currentNode++;
        }
        if (i == tree.count - 1 && i < lastNodeIndex) {
            int perLineSpaceCharCount = 3 * maxNodeNumber / (maxNodeNumber + 1);
            NSMutableString *spaceCharStr = [NSMutableString string];
            for (int idx = 0; idx < perLineSpaceCharCount; idx++) {
                [spaceCharStr appendString:@" "];
            }
            [currentNodeStr appendString:spaceCharStr];
            for (int d = 0; d < currenLevelNodeArray.count; d++) {
                [currentNodeStr appendFormat:@"%@%@", currenLevelNodeArray[d], spaceCharStr];
            }
            NSLog(@"%@", currentNodeStr);
            currentNodeStr = [NSMutableString string];
            [currenLevelNodeArray removeAllObjects];
        }
    }
}

#pragma mark - operation for heap
- (NSArray *)heapCreate:(NSArray *)array {
    NSMutableArray *heap = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self heapInsert:heap index:idx value:[obj integerValue]];
    }];
    return heap;
}

- (void)heapInsert:(NSMutableArray *)heap index:(NSInteger)index value:(NSInteger)value {
    [heap addObject:@(value)];
    [self shiftUp:heap];
}

- (void)heapPop:(NSMutableArray *)heap {
    if (heap.count > 0) {
        [heap exchangeObjectAtIndex:0 withObjectAtIndex:heap.count - 1];
        [heap removeLastObject];
        [self shiftDown:heap];
    }
}

// 自底向上调整
- (void)shiftUp:(NSMutableArray *)tree {
    NSInteger index = tree.count - 1;
    while (index > 0) {
        NSInteger fatherIndex = (index - 1) / 2;
        NSInteger leftChildIndex = fatherIndex * 2 + 1;
        NSInteger rightChildIndex = fatherIndex * 2 + 2;
        if (rightChildIndex <= index && [tree[fatherIndex] integerValue] > [tree[rightChildIndex] integerValue]) {
            // 交换
            [tree exchangeObjectAtIndex:fatherIndex withObjectAtIndex:rightChildIndex];
        }
        if (leftChildIndex <= index && [tree[fatherIndex] integerValue] > [tree[leftChildIndex] integerValue]) {
            [tree exchangeObjectAtIndex:fatherIndex withObjectAtIndex:leftChildIndex];
        }
        index = fatherIndex;
    }
}

// 自顶向下调整
- (void)shiftDown:(NSMutableArray *)tree {
    NSInteger currenNode = 0;
    BOOL needsChange = YES;
    while (needsChange) {
        NSInteger leftChildIndex = currenNode * 2 + 1;
        NSInteger rightChildIndex = currenNode * 2 + 2;
        if ((rightChildIndex >= tree.count || [tree[rightChildIndex] integerValue] > [tree[currenNode] integerValue]) &&
            (leftChildIndex >= tree.count || [tree[leftChildIndex] integerValue] > [tree[currenNode] integerValue])) {
            needsChange = NO;
        } else {
            if (rightChildIndex >= tree.count || [tree[rightChildIndex] integerValue] > [tree[leftChildIndex] integerValue]) {
                [tree exchangeObjectAtIndex:currenNode withObjectAtIndex:leftChildIndex];
                currenNode = leftChildIndex;
            } else {
                [tree exchangeObjectAtIndex:currenNode withObjectAtIndex:rightChildIndex];
                currenNode = rightChildIndex;
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *noRankArr = @[@4,@13,@7,@12,@17,@6,@5,@14,@11,@17,@14];
    NSArray *noRankArr = [self createRandomArrayWithCount:11];
    NSMutableArray *heap = [NSMutableArray arrayWithArray:[self heapCreate:noRankArr]];
    [self printTree:heap];
}

@end
