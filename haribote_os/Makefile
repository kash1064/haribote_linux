SHELL=/bin/bash
MS32GCC := gcc -fno-pie -m32 -march=i486 -nostdlib -c
NASM := nasm

NASMFILE_DIR := /haribote/src/nasm
CFILE_DIR := /haribote/src/c
LDFILE_DIR := /haribote/tools/ld

LSTFILE_DIR := /haribote/outputs/lst
OBJFILE_DIR := /haribote/outputs/obj
HRBFILE_DIR := /haribote/outputs/hrb

asmfunc.bin: ${NASMFILE_DIR}/asmfunc.asm Makefile
	nasm -g -f elf ${NASMFILE_DIR}/asmfunc.asm -o ${OBJFILE_DIR}/asmfunc.bin -l ${LSTFILE_DIR}/asmhead.lst

hlt.hrb: ${NASMFILE_DIR}/hlt.asm Makefile
	nasm ${NASMFILE_DIR}/hlt.asm -o ${HRBFILE_DIR}/hlt.hrb
	
%.bin : ${NASMFILE_DIR}/%.asm Makefile
	$(NASM) ${NASMFILE_DIR}/$*.asm -o ${OBJFILE_DIR}/$*.bin -l ${LSTFILE_DIR}/$*.lst

%.obj : ${CFILE_DIR}/%.c Makefile
	$(MS32GCC) ${CFILE_DIR}/$*.c -o ${OBJFILE_DIR}/$*.obj

%.hrb: ${CFILE_DIR}/%.c ${NASMFILE_DIR}/a_nasm.asm Makefile
	gcc -c -m32 -fno-pic -fno-stack-protector ${CFILE_DIR}/$*.c -o ${OBJFILE_DIR}/$*.o
	nasm -f elf32 ${NASMFILE_DIR}/a_nasm.asm -o ${OBJFILE_DIR}/a_nasm.o
	ld -m elf_i386 -o ${HRBFILE_DIR}/$*.hrb -T ${LDFILE_DIR}/a.ld ${OBJFILE_DIR}/a_nasm.o ${OBJFILE_DIR}/$*.o

bootpack.hrb : ${CFILE_DIR}/bootpack.c ${LDFILE_DIR}/har.ld  asmfunc.bin hankaku.obj mysprintf.obj dsctbl.obj graphic.obj int.obj fifo.obj keybord.obj mouse.obj memory.obj sheets.obj timer.obj mtask.obj strcmp.obj console.obj window.obj file.obj Makefile # Cファイルをリンカスクリプトを用いてコンパイル
	gcc -march=i486 -m32 -fno-pie -nostdlib -T ${LDFILE_DIR}/har.ld -g \
		${CFILE_DIR}/bootpack.c ${OBJFILE_DIR}/asmfunc.bin ${OBJFILE_DIR}/hankaku.obj \
		${OBJFILE_DIR}/mysprintf.obj ${OBJFILE_DIR}/dsctbl.obj ${OBJFILE_DIR}/graphic.obj \
		${OBJFILE_DIR}/int.obj ${OBJFILE_DIR}/fifo.obj ${OBJFILE_DIR}/memory.obj ${OBJFILE_DIR}/sheets.obj \
		${OBJFILE_DIR}/keybord.obj ${OBJFILE_DIR}/mouse.obj ${OBJFILE_DIR}/timer.obj ${OBJFILE_DIR}/mtask.obj \
		${OBJFILE_DIR}/strcmp.obj ${OBJFILE_DIR}/console.obj ${OBJFILE_DIR}/window.obj ${OBJFILE_DIR}/file.obj \
		-o ${HRBFILE_DIR}/bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat ${OBJFILE_DIR}/asmhead.bin ${HRBFILE_DIR}/bootpack.hrb > ${OBJFILE_DIR}/haribote.sys

haribote.img : ipl.bin hlt.hrb haribote.sys a.hrb winhelo.hrb star.hrb line.hrb noodle.hrb color.hrb Makefile
	mformat -f 1440 -C -B ${OBJFILE_DIR}/ipl.bin -i haribote.img ::
	mcopy ${OBJFILE_DIR}/haribote.sys -i haribote.img ::
	mcopy -i haribote.img ${HRBFILE_DIR}/hlt.hrb ::
	mcopy -i haribote.img ${HRBFILE_DIR}/a.hrb ::
	mcopy -i haribote.img ${HRBFILE_DIR}/winhelo.hrb ::
	mcopy -i haribote.img ${HRBFILE_DIR}/star.hrb ::
	mcopy -i haribote.img ${HRBFILE_DIR}/line.hrb ::
	mcopy -i haribote.img ${HRBFILE_DIR}/noodle.hrb ::
	mcopy -i haribote.img ${HRBFILE_DIR}/color.hrb ::


test: ipl.bin
	mformat -f 1440 -C -B ${OBJFILE_DIR}/ipl.bin -i haribote.img ::
	make start_quem
	
start_quem:
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy -nographic

clear :
	rm *.lst *.bin *.sys *.img *.hrb *.obj *.o

m := autopush
branch := origin master
autopush : ## This is auto push module, need commit message(default=autopush)
	git add .
	git commit -m "${m}"
	git push ${branch}

# Docker
pwd := `pwd`
login_container:
	docker run --rm -it --user ubuntu -v ${pwd}:/haribote haribote /bin/bash -login
	# docker run --rm -it -v ${pwd}:/kurara_os kurara_os_x86_64 /bin/bash

start_docker:
	sudo /etc/init.d/docker start