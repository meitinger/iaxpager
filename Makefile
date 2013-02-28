!include <win32.mak>

svcname=iax-pager
exename=$(svcname).exe
exepath="%SystemRoot%\system32\$(exename)"

all: $(exename)

clean:
	DEL /S *.exe *.obj *.pdb

$(exename): iax.obj iax2-parser.obj jitterbuf.obj md5.obj host.obj settings.obj wave.obj service.obj main.obj
	$(link) $(ldebug) $(conflags) -out:$@ $** $(conlibs) winmm.lib

.c.obj:
	$(cc) $(cdebug) $(cflags) $(cvars) /DSERVICE_NAME="""$(svcname)""" /D_CRT_SECURE_NO_WARNINGS $<

install: $(exename)
	COPY /Y /V $(exename) $(exepath)
	SC create $(svcname) start= auto binPath= $(exepath) DisplayName= "IAX Pager"
	SC start $(svcname)

uninstall:
	SC stop $(svcname)
	SC delete $(svcname)
	DEL $(exepath)
