package aoc

fun unreachable(): Nothing = throw IllegalStateException()

fun Boolean.toInt() = compareTo(false)

fun <T> Iterable<T>.indexOfOrNull(el: T) = indexOf(el).takeIf { it != -1 }
