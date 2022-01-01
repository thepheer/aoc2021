time := time -f "%E real, %U user, %S sys, %P cpu, %Mk mem"

c++_flags := -std=c++20
d_flags := -q
crystal_flags :=
nim_flags := --hints:off
odin_flags := -strict-style
rust_flags := -q
zig_flags := -fsingle-threaded

ifdef RELEASE
rust_path := release
c++_flags += -O3
d_flags += -b=release-nobounds
crystal_flags += --release
nim_flags += -d:danger
odin_flags += -no-bounds-check -opt:3
rust_flags += --release
zig_flags += --strip -O ReleaseFast -lc
else
rust_path := debug
odin_flags += -debug -vet
endif

.PHONY: all c++ d kotlin nim odin rust zig julia
all: c++ d kotlin nim odin rust zig julia

c++:
	$(info --- $@ ---)
	@cd $@; g++-11 $(c++_flags) -o aoc aoc.cpp util.cpp
	@$(time) ./$@/aoc

d:
	$(info --- $@ ---)
	@cd $@; dub build $(d_flags)
	@$(time) ./$@/aoc

julia:
	$(info --- $@ ---)
	@$(time) julia ./$@/aoc.jl

nim:
	$(info --- $@ ---)
	@cd $@; nim c $(nim_flags) aoc
	@$(time) ./$@/aoc

kotlin:
	$(info --- $@ ---)
	@cd $@; kotlinc -jvm-target 17 -d aoc.jar *.kt */*.kt
	@$(time) kotlin -cp $@/aoc.jar aoc.AocKt

odin:
	$(info --- $@ ---)
	@cd $@; odin build aoc.odin $(odin_flags)
	@$(time) ./$@/aoc

rust:
	$(info --- $@ ---)
	@cd $@; cargo build $(rust_flags)
	@$(time) ./$@/target/$(rust_path)/aoc

zig:
	$(info --- $@ ---)
	@cd $@; zig build-exe $(zig_flags) aoc.zig
	@$(time) ./$@/aoc

# crystal:
# 	$(info --- $@ ---)
# 	@cd $@; crystal build $(crystal_flags) aoc.cr
# 	@$(time) ./$@/aoc
