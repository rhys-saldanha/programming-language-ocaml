exception LexError
exception ParseError

open MachineLang
open Lexer
open Parser
open Arg

let parseProgram c =
    try 
		let lexbuf = Lexing.from_string c in
            parser_main lexer_main lexbuf
    with Parsing.Parse_error -> raise ParseError
		| Failure "lexing: empty token" -> raise LexError
;;

let _ =
	try
		let file = open_in Sys.argv.(1) in
		while true do
			let line = input_line file in
			let parsed = parseProgram line in
			let _ = typeProg parsed	in
			(* print_string "Program Type\t\t==> Checked\n"; *)
			let result3 = bigEval parsed in
			(* print_string "Program Evaluated\t==> " ; *)
			let () = print_res result3; in
				flush stdout
		done
	with End_of_file -> exit 0
		| LexError -> prerr_string ("Lexing Error : Invalid characters"); prerr_newline ()
		| ParseError -> prerr_string ("Parsing Error : Invalid syntax"); prerr_newline ()
		| TypeError x -> prerr_string ("Type Error : " ^ x); prerr_newline ()
		| InputError x -> prerr_string ("Input Error : " ^ x); prerr_newline ()
		| EvalError x -> prerr_string ("Evaluation Error : " ^ x); prerr_newline ()
		| StuckTerm -> prerr_string ("Unexpected evaluation, report to dev team"); prerr_newline ()
		| PrintError x -> prerr_string ("Print Error : " ^ x); prerr_newline ()
		