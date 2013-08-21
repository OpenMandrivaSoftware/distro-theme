
(define (gimp-convert-to-jpeg quality infile outfile)
   (let* ((image (car (file-png-load 1 infile infile)))
         )
	
	(gimp-image-flatten image)

     	(let* ((drawable (car (gimp-image-get-active-drawable image))))
		(if (= (car (gimp-drawable-is-rgb drawable)) FALSE)
		    (gimp-image-convert-rgb image))

		(file-jpeg-save 1 image drawable outfile outfile quality 0 1 0 "Moondrake Theme" 2 1 0 2 )
		(gimp-image-delete image)
	 )
	
   )
)
