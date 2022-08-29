" Title: Project Manager
" Author: Lou Noizet
" Maintainer: Lou Noizet (lou@noizet.fr)
" Description: This plugin tries to find the project root. It is very basic

if exists("g:project_manager")
    finish
endif
let g:project_manager = 1


"""""""""" Project handling
function! FindProjectRoot(lookFor)
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let fileToCheck=expand(pathMaker).'/'.a:lookFor
        if filereadable(fileToCheck)||isdirectory(fileToCheck)
            return expand(pathMaker)
        endif
    endwhile
    return ""
endfunction

function! DuneConfig()
		setlocal makeprg=dune
		map <buffer> <space>mm <Cmd>make build<CR>
		map <buffer> <space>mt <Cmd>make test<CR>
		map <buffer> <space>mc <Cmd>make clean<CR>
endfunction

function! MakeConfig()
		setlocal makeprg=make
		map <buffer> <space>mm <Cmd>make<CR>
		map <buffer> <space>mt <Cmd>make test<CR>
		map <buffer> <space>mc <Cmd>make clean<CR>
endfunction

let g:project_chdir_root = "true"

function! ConfigProject()
	" Try dune
	let g:project_root = FindProjectRoot('dune-project')
	if !empty(g:project_root)
		let g:project_type = 'dune'
		call DuneConfig()
	else
		" Try Makefile
		let g:project_root = FindProjectRoot('Makefile')
		if !empty(g:project_root)
			let g:project_type = 'make'
			call MakeConfig()
		endif
	endif

	if exists("g:project_chdir_root") && g:project_chdir_root == "true" && exists(g:project_type)
		exe 'lcd' g:project_root
	endif
endfunction

au BufEnter * call ConfigProject()
