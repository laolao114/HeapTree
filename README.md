# HeapTree
## 题目： 如何快速在一个无序数组中，找出前k个最大的值？
解题思路： 无序数组找前k个最值，符合最大堆/最小堆模型，直接用堆就行了

## 0.如何用数组表示一棵树
树形结构的表示，可以有两种，一种是基于结构体/类的链表结构，每个节点分别用指针来保存子节点的地址。访问时需要根据根节点来访问，访问某一子节点时需要遍历对应的父节点；另一种是基于下标的数组结构，根据堆一定是一颗完全二叉树这样的性质，可得知，节点i的子节点一定是 2i+1 和 2i+2，访问某一子节点时只需要直接访问数组下标就行了。
## 1. 建树/插入（自底向上调整）
当有新元素插入时，要自底向上调整树，使树符合最大堆的要求。所谓调整就是指：比较当前节点与父节点的大小，如果父节点较小就交换父节点与子节点的值。每次调整至根节点或者不发生交换时（最大堆中，父节点永远大于子节点，不发生交换，说明该节点的父节点及祖父节点比当前节点大，就没必要继续调整了）就终止。
建树过程就是遍历一次数组，并将数组的每一个节点都插入到树中，便完成了建树。

```objective-c
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
```

## 2. 删除（自顶向下调整）
理论上，最大堆应该只能删除堆顶的数据，但事实上你可以把要删除的某个特定子节点看成是 以当前节点为根节点 对应的子树，所以如果你想要删除某个特定节点的话也是与根节点类似的方法，因此我们这里只讨论删除堆顶的情况。删除堆顶数据时，首先把要 删除的节点的数据 和 树尾部的数据 交换后删除，此时原树尾的数据位置在根节点，并且大概率是不符合最大堆的规则，因此要做一次自顶向下的调整。同样，调整从当前节点开始，比较当前节点与两个子节点的大小，与较大的子节点进行交换，调整直至没有值发生变化或者抵达树的底部。
```objective-c
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
```
## 3. 可选部分（打印树）
为了方便查看最终的结果是否正确，添加了一个打印树的功能。

上述题目，通过k次取出并删除树顶数据即可解决。建树时间复杂度是n，每次删除时间复杂是log(n)。
