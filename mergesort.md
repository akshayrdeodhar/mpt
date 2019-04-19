# How I wasted my time writing mergesort in assembly on the eve of MPT pracs

I thought, "It's recursion! No need to unveil it! Let's write mergesort as practice'

## IT SEEMS THAT I HAVE NO TIME FOR A BLOG POST NOW. JUST SOME TIPS

* Build helper functions one by one, ground up. Test each independently and rigorously
* Think before you write a procedure- it is difficult to modify assembly code after you have written it
* Always be using procedures where you protect registers before using them
* If you are using ax as a return value, be minful that if you do not push ax before calling a procedure, it **will** get modified. This was my *biggest mistake* while writing the mergesort procedure
* When you do l1 = length - almosthalf, add almosthalf to base pointer to get the \*other\* array. Now, length of first array is \*l1\*, **not** almosthalf
* Recursion is easy to debug- don't try to debug it by unraveling it. That's *stupid*. 

> Do not unravel recursion

