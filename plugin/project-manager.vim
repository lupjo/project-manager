" Title: Project Manager
" Author: Victoire Noizet
" Maintainer: Victoire Noizet (Victoire@noizet.fr)
" Description: This plugin tries to find the project root. It is very basic

if exists("g:project_manager")
    finish
endif
let g:project_manager = 1




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


function! FindProjectRoot()
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let checkdune=expand(pathMaker).'/dune-project'
        if filereadable(checkdune)||isdirectory(checkdune)
            let g:project_type = 'dune'
            call DuneConfig()
            return expand(pathMaker)
        endif
        let checkmake=expand(pathMaker).'/Makefile'
        if filereadable(checkmake)||isdirectory(checkmake)
            let g:project_type = 'make'
            call MakeConfig ()
            return expand(pathMaker)
        endif
    endwhile
    return ""
endfunction

let g:project_chdir_root = "true"

function! ConfigProject()
	let g:project_root = FindProjectRoot()
	if exists("g:project_chdir_root") && g:project_chdir_root == "true" && exists("g:project_type")
		exe 'lcd' g:project_root
	endif
endfunction

au BufEnter * call ConfigProject()
