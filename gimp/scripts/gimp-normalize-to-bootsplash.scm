; dmmScalePNG.scm - GIMP Script-Fu to Scale a PNG Image to a New Width
;    This Script-Fu must be put in The GIMP's script directory
;    (e.g., $HOME/.gimp-1.2/scripts).
;    For interactive invocation, run The GIMP and go to
;    Xtns -> Script-Fu -> dmm
;    New width is in pixels
;

(define (gimp-normalize-to-bootsplash-dirs quality dirpattern pattern)
   (let* ((dirs (file-glob dirpattern 1))
	  (count (car dirs))
	  (dirlist (cadr dirs))
	  (i 0))
     (while (< i count)
	    (let* ((dirname (aref dirlist i))
		   (filepattern (strcat dirname "/" pattern)))
	      (gimp-message (strcat "Browsing " filepattern))
	      (gimp-normalize-to-bootsplash-files quality filepattern))
	    (set! i (+ i 1)))))

(define (gimp-normalize-to-bootsplash-files quality pattern)
   (let* ((files (file-glob pattern 1))
	  (count (car files))
	  (filelist (cadr files))
	  (i 0))
     (while (< i count)
	    (let* ((infile (aref filelist i))
		   (outfile (strcat (car (strbreakup infile ".")) ".jpg")))
	      (gimp-message (strcat "Processing " infile))
	      (gimp-normalize-to-bootsplash quality infile outfile))
	    (set! i (+ i 1)))))

(define (gimp-normalize-to-bootsplash quality infile outfile)
   (let* ((image (car (gimp-file-load 1 infile infile)))
         )
	
	(gimp-image-flatten image)

     	(let* ((drawable (car (gimp-image-get-active-drawable image))))
		(if (= (car (gimp-drawable-is-rgb drawable)) FALSE)
		    (gimp-image-convert-rgb image))

		(file-jpeg-save 1 image drawable outfile outfile quality 0 0 0 "Moondrake Theme" 0 1 0 0 )
		(gimp-image-delete image)
	 )
	
   )
)

(script-fu-register                                 ; I always forget these ...
   "gimp-normalize-to-bootsplash"                                    ; script name to register
   "<Image>/Filters/Mandriva/Save the jpeg image to the right format for bootsplash"       ; where it goes
   "Transform an image to a jpg compatible image for bootsplash"   ; script description
   "Warly/blino"                             ; author
   "Copyright 2006 by Mandriva; GNU GPL"  ; copyright
   "2006-09-01"                                     ; date
   ""	; type of image
   SF-VALUE "Quality" "0.9"                        ; default quality
   SF-FILENAME "Infile" "infile.png"
   SF-FILENAME "Infile" "outfile.jpg"
)
