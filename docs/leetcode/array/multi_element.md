# 多数元素

## leetcode 169

给定一个大小为 n 的数组，找到其中的多数元素。多数元素是指在数组中出现次数大于 ⌊ n/2 ⌋ 的元素。

你可以假设数组是非空的，并且给定的数组总是存在多数元素。

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/majority-element
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。

### **分析**

对于数组来说有序和无序所有从有序和无序进行解答

#### **解法一**

如果有序，对于有序的数组，如果其中一个数出现的频率大于数组长度的一半，那么其中位数就已经是需要选出的数。

```go
func majorityElement(nums []int) int {
    return nums[len(nums)/2]
}
```

如果是无序的可以考虑排序后再去其中位数。

```go
func majorityElement(nums []int) int {
    sort.Ints(nums)
    return nums[len(nums)/2]
}
```

#### **解法二**

对于无序的数组还可以用一个额外的空间进行统计一个每个数的频率，然后再找出其中频率最大的，最后判断其频率是否大于n/2。

但这个方法需要一个额外的map或者其他可以达到记录数组中数的频率的目的。

这里在介绍一种方法可以使时间复杂度为log2n 空间复杂度为1,该算法的思想是遍历数组，标记一个可能数需要查找的数num，同样记录num的频率。最后确定num是不是频率大于n/2的数

算法可以分为两步：

1. 选取候选的主元素，一次遍历数组，将第一个越到的整数num保存到c中，记录num出现的次数为1。若遇到下一个数还是num则计数+1反之-1。当计数为0时，将遇到的下一个数保存到num中，重当前位置重复之前的操作，开始新的计数。最后会得到c和其出现的次数
2. 判断c是否是真正的出现频率超过n/2的数，若是则c为目标元素，如不是这没有目标元素

```
func majorityElement(nums []int) int {
   c:=nums[0]
	count:=1
	for i:=1;i< len(nums);i++  {
		if c == nums[i] {
			count++
		}else {
			count--
			if count == 0 {
				c=nums[i]
				count++
			}
		}
	}
	count = 0
	for i := range nums {
		if nums[i] == c {
			count++
		}
	}
	if count> len(nums)/2 {
		return c
	}else {
        return 0
    }
}
```

