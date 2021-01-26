tinyraycaster:
	zig build-exe tinyraycaster.zig -lc

test: tinyraycaster
	./tinyraycaster && sxiv out.ppm

clean:
	rm -f tinyraycaster out.ppm

.PHONY: tinyraycaster test clean
