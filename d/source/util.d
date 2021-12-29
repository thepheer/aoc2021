module util;

import std;

void removeUnordered(T)(ref T[] items, ulong index) {
  items = items.remove!(SwapStrategy.unstable)(index);
}

template retainUnordered(alias predicate) if (is(typeof(unaryFun!predicate))) {
  void retainUnordered(T)(ref T[] items) {
    foreach_reverse (i, ref item; items)
      if (!predicate(item))
        items.removeUnordered(i);
  }
}
