# Automatic building of the demo
# Krusty/Benediction 2011

include CPC.mk
.SILENT:

#############
# Constants #
#############
# DSK
DSK = 4k_stop_that_nyan_cat.dsk
HFE = 4k_stop_that_nyan_cat_dsk.hfe
EXEC = STOP.CAT

BOOTSTRAP_LOAD=x8000
BOOTSTRAP_EXEC=x8000

vpath %.asm 	src/ 

.SUFFIXES: .asm, .o, .exo, .cre

vpath %.o .
vpath %.exo .
vpath %.cre .

.PHONY: all
ALL: 
	$(MAKE) $(DSK) 

############################
# Extract data if required #
############################

################################
# Dependicies for source files #
################################
# TODO Automatically compute them

revision.o: chunky_plasma.asm  display_chunky.asm  revision.asm src/bump/bump.asm src/data.asm \
	src/bump/bump_image.asm \
	src/ArkosTrackerPlayer_CPC_MSX.asm \
	src/intro.asm \
    src/fade.asm \
    data/sin_precomputed.asm   \
   src/water.asm \
   src/tunnel.asm
bootstrap.o: revision.exo

##############
# Build data #
##############
src/bump/bump_image.asm: data/bumpmap/texture.bmp
	echo Build image
	python tools/image_to_array.py $^ > $@

#######
# DSK #
#######
#$(EXEC): bootstrap.o
#	@$(call SET_HEADER, $<, $@, $(AMSDOS_BINARY), $(BOOTSTRAP_LOAD), $(BOOTSTRAP_EXEC))

$(EXEC): bootstrap.o
	@$(call SET_HEADER, $<, $@, $(AMSDOS_BINARY), $(BOOTSTRAP_LOAD), $(BOOTSTRAP_EXEC))
	@echo '======================================================>' \
		$$((3968 - $$(ls -ali bootstrap.o | awk '{print $$6}'))) bytes available 

FILES_TO_PUT= $(EXEC) 
$(DSK): $(FILES_TO_PUT)
	$(call CREATE_DSK, $@)
	cpcfs -b $(DSK) p  $(EXEC)
	#@$(foreach file, $(FILES_TO_PUT), \
		$(call PUT_FILE_INTO_DSK2, $@, $(file)) )

#############
# Utilities #
# ###########
.PHONY: clean distclean check archive
check:
	bash ./tools/check_source_validity.sh || ($(MAKE) clean ; exit 1)
clean:
	-rm $(DATA_SONG_FILE)
	-rm $(DATA_PLAYER_FILE)
	-rm *.o 
	-rm *.bin
	-rm *.exo
	-rm *.lst
	-find . -name "*.sym" -delete

distclean: clean
	-rm $(DSK)
	-rm $(HFE)



archive:
	-rm -rf output 	
	mkdir output
	cp $(DSK) output     
	cp data/File.idz output 
	cp data/Note.txt output 
	cp data/screenshot.png     output
	cd output ; \
    tar -cvzf ../stop_nyan_cat.tar.gz *

$(HFE): $(DSK)
	hxcfloppyemulator_convert  $(DSK) -HFE
