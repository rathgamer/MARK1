	BITS 16

	%DEFINE MARK_VER '1'	
	%DEFINE MARK_API_VER 17

	disk_buffer	equ	24576
	
os_call_vectors:
	jmp os_main			
	jmp os_print_string	
	jmp os_move_cursor	
	jmp os_clear_screen	
	jmp os_print_horiz_line		
	jmp os_print_newline		
	jmp os_wait_for_key		
	jmp os_check_for_key	
	jmp os_int_to_string	
	jmp os_speaker_tone		
	jmp os_speaker_off		
	jmp os_load_file		
	jmp os_pause			
	jmp os_fatal_error		
	jmp os_draw_background	
	jmp os_string_length	
	jmp os_string_uppercase	
	jmp os_string_lowercase		
	jmp os_input_string		
	jmp os_string_copy		
	jmp os_dialog_box		
	jmp os_string_join		
	jmp os_get_file_list	
	jmp os_string_compare	
	jmp os_string_chomp		
	jmp os_string_strip		
	jmp os_string_truncate	
	jmp os_bcd_to_int		
	jmp os_get_time_string	
	jmp os_get_api_version	
	jmp os_file_selector		
	jmp os_get_date_string		
	jmp os_send_via_serial		
	jmp os_get_via_serial	
	jmp os_find_char_in_string	
	jmp os_get_cursor_pos		
	jmp os_print_space		
	jmp os_dump_string		
	jmp os_print_digit		
	jmp os_print_1hex		
	jmp os_print_2hex		
	jmp os_print_4hex		
	jmp os_long_int_to_string	
	jmp os_long_int_negate		
	jmp os_set_time_fmt		
	jmp os_set_date_fmt		
	jmp os_show_cursor		
	jmp os_hide_cursor		
	jmp os_dump_registers	
	jmp os_string_strincmp	
	jmp os_write_file		
	jmp os_file_exists		
	jmp os_create_file		
	jmp os_remove_file		
	jmp os_rename_file	
	jmp os_get_file_size
	jmp os_input_dialog		
	jmp os_list_dialog		
	jmp os_string_reverse	
	jmp os_string_to_int	
	jmp os_draw_block		
	jmp os_get_random		
	jmp os_string_charchange
	jmp os_serial_port_enable	
	jmp os_sint_to_string		
	jmp os_string_parse		
	jmp os_run_basic	
	jmp os_port_byte_out		
	jmp os_port_byte_in		
	jmp os_string_tokenize		

os_main:
	cli				
	mov ax, 0
	mov ss, ax			
	mov sp, 0FFFFh
	sti				

	cld				
					

	mov ax, 2000h	
	mov ds, ax		
	mov es, ax		
	mov fs, ax		
	mov gs, ax

	cmp dl, 0
	je no_change
	mov [bootdev], dl		
	push es
	mov ah, 8			
	int 13h
	pop es
	and cx, 3Fh			
	mov [SecsPerTrack], cx		
	movzx dx, dh			
	add dx, 1			
	mov [Sides], dx

no_change:
	mov ax, 1003h		
	mov bx, 0			
	int 10h

	call os_seed_random		

	mov ax, autorun_bin_file_name
	call os_file_exists
	jc no_autorun_bin		

	mov cx, 32768			
	call os_load_file
	jmp execute_bin_program	

no_autorun_bin:
	mov ax, autorun_bas_file_name
	call os_file_exists
	jc option_screen		

	mov cx, 32768			
	call os_load_file
	call os_clear_screen
	mov ax, 32768
	call os_run_basic		

	jmp app_selector		

option_screen:
	mov ax, os_init_msg		
	mov bx, os_version_msg
	mov cx, 10011111b		
	call os_draw_background

	mov ax, dialog_string_1	
	mov bx, dialog_string_2
	mov cx, dialog_string_3
	mov dx, 1			
	call os_dialog_box

	cmp ax, 1			
	jne near app_selector

	call os_clear_screen		
	call os_command_line

	jmp option_screen		


	

	os_init_msg		db 'HELLO THIS IS MARK 1', 0
	os_version_msg		db 'Version ', MARK_VER, 0

	dialog_string_1		db 'HELLO!', 0
	dialog_string_2		db 'Select an interface: OK for the', 0
	dialog_string_3		db 'Program Menu, CANCEL for command line.', 0



app_selector:
	mov ax, os_init_msg	
	mov bx, os_version_msg
	mov cx, 10011111b	
	call os_draw_background

	call os_file_selector
					
	jc option_screen		

	mov si, ax			
	mov di, kern_file_name
	call os_string_compare
	jc no_kernel_execute		

	push si				

	mov bx, si
	mov ax, si
	call os_string_length

	mov si, bx
	add si, ax			

	dec si
	dec si
	dec si				

	mov di, bin_ext
	mov cx, 3
	rep cmpsb			
	jne not_bin_extension		

	pop si				


	mov ax, si
	mov cx, 32768		
	call os_load_file		


execute_bin_program:
	call os_clear_screen	

	mov ax, 0			
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov si, 0
	mov di, 0

	call 32768			

	mov si, program_finished_msg	
	call os_print_string		
	call os_wait_for_key

	call os_clear_screen		
	jmp app_selector		


no_kernel_execute:			
	mov ax, kerndlg_string_1
	mov bx, kerndlg_string_2
	mov cx, kerndlg_string_3
	mov dx, 0			
	call os_dialog_box

	jmp app_selector	


not_bin_extension:
	pop si				

	push si				

	mov bx, si
	mov ax, si
	call os_string_length

	mov si, bx
	add si, ax			

	dec si
	dec si
	dec si				

	mov di, bas_ext
	mov cx, 3
	rep cmpsb			
	jne not_bas_extension		


	pop si

	mov ax, si
	mov cx, 32768			
	call os_load_file		

	call os_clear_screen	

	mov ax, 32768
	mov si, 0			
	call os_run_basic	

	mov si, program_finished_msg
	call os_print_string
	call os_wait_for_key

	call os_clear_screen
	jmp app_selector	


not_bas_extension:
	pop si

	mov ax, ext_string_1
	mov bx, ext_string_2
	mov cx, 0
	mov dx, 0			
	call os_dialog_box

	jmp app_selector	

	kern_file_name		db 'KERNEL.BIN', 0

	autorun_bin_file_name	db 'AUTORUN.BIN', 0
	autorun_bas_file_name	db 'AUTORUN.BAS', 0

	bin_ext			db 'BIN'
	bas_ext			db 'BAS'

	kerndlg_string_1	db 'Cannot load and execute MARK 1 kernel!', 0
	kerndlg_string_2	db 'KERNEL.BIN is the core of MARK 1, and', 0
	kerndlg_string_3	db 'is not a normal program.', 0

	ext_string_1		db 'Invalid filename extension! You can', 0
	ext_string_2		db 'only execute .BIN or .BAS programs.', 0

	program_finished_msg	db '>>> TERMINATED. Press any key to continue', 0

	fmt_12_24	db 0		

	fmt_date	db 0, '/'	
					
	%INCLUDE "features/cli.asm"
 	%INCLUDE "features/disk.asm"
	%INCLUDE "features/keyboard.asm"
	%INCLUDE "features/math.asm"
	%INCLUDE "features/misc.asm"
	%INCLUDE "features/ports.asm"
	%INCLUDE "features/screen.asm"
	%INCLUDE "features/sound.asm"
	%INCLUDE "features/string.asm"
	%INCLUDE "features/basic.asm"
