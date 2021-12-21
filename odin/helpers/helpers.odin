package helpers

import "core:mem"

slice_into_dynamic :: proc(a: $T/[]$E, allocator := context.allocator) -> [dynamic]E {
	s := transmute(mem.Raw_Slice)a
	d := mem.Raw_Dynamic_Array{ data = s.data, len = s.len, cap = s.len, allocator = allocator }
	return transmute([dynamic]E)d
}
