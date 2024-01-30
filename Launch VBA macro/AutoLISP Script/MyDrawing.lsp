(vl-load-com)

(defun c:MyDrawing(/
                   msgbox_title
                   dvb_filename
                   macro_name
                   dvb_search_dir
                   dvb_search_path
                   dvb_found_path
                   find_file_result
                   msg
                   reply
                   )
  
  (setq msgbox_title "My Drawing")
  (setq dvb_filename "MyDrawing.dvb")
  (setq macro_name "MyDrawing.MyDrawing")
  
  ; GET AUTOCAD INSTALLATION DIRECTORY
  ; LET'S EXPECT THE DVB FILE SHOULD BE PRESENT IN AUTOAD'S INSTALLATION DIRECTORY
  (setq dvb_search_dir (vl-filename-directory (vlax-get-property (vlax-get-acad-object) "FullName")))
 
  ; DVB PATH AS EXPECTED
  (setq dvb_search_path (strcat dvb_search_dir "\\" dvb_filename))
  
  ; ENSURE THE DVB FILE IS IN THE "SEARCH DIR" AS EXPECTED.
  (setq find_file_result (findfile dvb_search_path))
  (if (= find_file_result nil)
    (progn
      (setq msg (strcat "The following dependancies could not be found.\n\n1. " dvb_search_path "\n\nWanna browse?"))
      (setq reply (ACET-UI-MESSAGE msg msgbox_title (+ Acet:YESNO Acet:ICONWARNING) ) )
      (if (= reply 6) ; Yes
        (progn
          (setq dvb_found_path (getfiled msgbox_title dvb_search_path (substr (vl-filename-extension dvb_filename) 2) 8)) ; MAKE THE EXTENSION DYNAMIC HERE
        )
        (progn
          (setq dvb_found_path nil)
        )
      )
    )
    (progn
      (setq dvb_found_path dvb_search_path)
    )
    
  )
  
    
  (if (/= dvb_found_path nil)
    (progn
      (launch_vba_macro dvb_found_path macro_name)
    )
  )  
  
  (princ)
)


(defun launch_vba_macro(arg_dvb_path arg_macro_name / acad_obj)
  (setq acad_obj (vlax-get-acad-object))
  (vla-LoadDVB acad_obj arg_dvb_path)
  (vla-RunMacro acad_obj arg_macro_name)
  ;(vla-UnloadDVB acad_obj arg_dvb_path) ; DON'T UNLOAD IF IT WAS PREVIOUSLY LOADED
)

