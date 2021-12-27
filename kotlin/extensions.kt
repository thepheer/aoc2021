package aoc.extensions

fun Boolean.toInt() = compareTo(false)

fun <T> Iterable<T>.indexOfOrNull(el: T) = indexOf(el).takeIf { it != -1 }