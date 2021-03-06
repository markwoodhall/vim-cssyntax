" Vim syntax file
" Language:             Microsoft C#
" Maintainer:           Kian Ryan (kian@orangetentacle.co.uk)
" Former Maintainer:    Anduin Withers (awithers@anduin.com)
" Filenames:            *.cs
"
" REFERENCES:
" [1] ECMA TC39: C# Language Specification (WD13Oct01.doc)

if exists("b:current_syntax")
    finish
endif

let s:cs_cpo_save = &cpo
set cpo&vim

" type
syn keyword csType			bool byte char decimal double float int long object sbyte short string uint ulong ushort void var dynamic Func Assert
" storage
syn keyword csTypeDecleration           class enum struct nextgroup=csClass skipwhite
syn keyword csStorage			delegate interface namespace struct
syn keyword csInterfaceDecleration      interface nextgroup=csIface skipwhite
" repeat / condition / label
syn keyword csRepeat			break continue do for foreach goto return while
syn keyword csConditional		else if switch case default
" :: is usually an error in C#, except for the special case of "global::"
syn match csOperatorError		display +::+
syn match csGlobal          display +global::+
" user labels (see [1] 8.6 Statements)
syn match   csLabel			display +^\s*\I\i*\s*:\([^:]\)\@=+
" modifier
syn keyword csModifier			abstract const extern internal override private protected readonly sealed static virtual volatile nextgroup=csClass,csIface skipwhite
syn keyword csPublicModifier		public nextgroup=csClass,csIface,csType skipwhite
syn keyword csPrivateModifier		private nextgroup=csClass,csIface,csType skipwhite
" constant
syn keyword csConstant			false null true
" exception
syn keyword csException			try catch finally throw

" TODO:
syn keyword csUnspecifiedStatement	as base checked event fixed in is lock operator out params ref sizeof stackalloc this unchecked unsafe using 
" TODO:
syn keyword csUnsupportedStatement	add remove value
" TODO:
syn keyword csUnspecifiedKeyword	explicit implicit

syn keyword csTypeOf                    typeof nextgroup=csEnclosed

" Linq Keywords
syn keyword csLinq                      from where select group into orderby join let in on equals by ascending descending

" Async Keywords
syn keyword csAsync                     async await

" Contextual Keywords
syn match csContextualStatement	/\<yield[[:space:]\n]\+\(return\|break\)/me=s+5
syn match csContextualStatement	/\<partial[[:space:]\n]\+\(class\|struct\|interface\)/me=s+7
syn match csContextualStatement	/\<\(get\|set\);/me=s+3
syn match csContextualStatement	/\<\(get\|set\)[[:space:]\n]*{/me=s+3
syn match csContextualStatement /\<where\>[^:]\+:/me=s+5



"New Declerations
syn keyword csNewDecleration            new nextgroup=csClass skipwhite

"Interface  & Class Identifier
syn keyword csClass Enum
syn match csClass contained       /\<[A-Z][A-Za-z]\w\+/ nextgroup=csGeneric
syn match csClass contained       /\<[A-Z][A-Za-z]\w\+/ nextgroup=csEnclosed
syn match csIface contained       /\<I[A-Z][A-Za-z]\w\+/ nextgroup=csGeneric
syn match csIface contained       /\<I[A-Z][A-Za-z]\w\+/ nextgroup=csEnclosed
"syn region csGeneric start="<" end=">" contains=csIface,csClass,csType
syn region csEnclosed start="(" end=")" contains=csConstant,csType,csString,csVerbatimString,csCharacter,csNumber,csIface,csClass
syn region csEnclosed start="(" end=")" contains=csConstant,csType,csString,csVerbatimString,csCharacter,csNumber,csIface,csClass
syn region csEnclosed start="(\[\w*\]" end=")" contains=csConstant,csType,csString,csVerbatimString,csCharacter,csNumber,csIface,csClass
"syn region csInherits start=":" end="{" contains=csIface,csClass

" Attributes
syn region csAttribute start="^\s*\[" end="\]\s*" contains=csString, csVerbatimString, csCharacter, csNumber, csType


" Comments
"
" PROVIDES: @csCommentHook
"
" TODO: include strings ?
"
syn keyword csTodo		contained TODO FIXME XXX NOTE
syn region  csComment		start="/\*"  end="\*/" contains=@csCommentHook,csTodo,@Spell
syn match   csComment		"//.*$" contains=@csCommentHook,csTodo,@Spell



syn match csAssignment  /\<[A-Z]\+[a-zA-Z]\+\>\s=\s/


" xml markup inside '///' comments
syn cluster xmlRegionHook	add=csXmlCommentLeader
syn cluster xmlCdataHook	add=csXmlCommentLeader
syn cluster xmlStartTagHook	add=csXmlCommentLeader
syn keyword csXmlTag		contained Libraries Packages Types Excluded ExcludedTypeName ExcludedLibraryName
syn keyword csXmlTag		contained ExcludedBucketName TypeExcluded Type TypeKind TypeSignature AssemblyInfo
syn keyword csXmlTag		contained AssemblyName AssemblyPublicKey AssemblyVersion AssemblyCulture Base
syn keyword csXmlTag		contained BaseTypeName Interfaces Interface InterfaceName Attributes Attribute
syn keyword csXmlTag		contained AttributeName Members Member MemberSignature MemberType MemberValue
syn keyword csXmlTag		contained ReturnValue ReturnType Parameters Parameter MemberOfPackage
syn keyword csXmlTag		contained ThreadingSafetyStatement Docs devdoc example overload remarks returns summary
syn keyword csXmlTag		contained threadsafe value internalonly nodoc exception param permission platnote
syn keyword csXmlTag		contained seealso b c i pre sub sup block code note paramref see subscript superscript
syn keyword csXmlTag		contained list listheader item term description altcompliant altmember

syn cluster xmlTagHook add=csXmlTag

syn match   csXmlCommentLeader	+\/\/\/+    contained
syn match   csXmlComment	+\/\/\/.*$+ contains=csXmlCommentLeader,@csXml,@Spell
syntax include @csXml syntax/xml.vim
hi def link xmlRegion Comment


" [1] 9.5 Pre-processing directives
syn region	csPreCondit
    \ start="^\s*#\s*\(define\|undef\|if\|elif\|else\|endif\|line\|error\|warning\)"
    \ skip="\\$" end="$" contains=csComment keepend
syn region	csRegion matchgroup=csPreCondit start="^\s*#\s*region.*$"
    \ end="^\s*#\s*endregion" transparent fold contains=TOP



" Strings and constants
syn match   csSpecialError	contained "\\."
syn match   csSpecialCharError	contained "[^']"
" [1] 9.4.4.4 Character literals
syn match   csSpecialChar	contained +\\["\\'0abfnrtvx]+

syn match   csInter             "{\S*}"
" unicode characters
syn match   csUnicodeNumber	+\\\(u\x\{4}\|U\x\{8}\)+ contained contains=csUnicodeSpecifier
syn match   csUnicodeSpecifier	+\\[uU]+ contained
syn region  csVerbatimString	start=+@"+ end=+"+ skip=+""+ contains=csVerbatimSpec,@Spell
syn match   csVerbatimSpec	+@"+he=s+1 contained
syn region  csInterpolatedString	start=+$"+ end=+"+ skip=+""+ contains=csInterpolatedSpec,@Spell
syn match   csInterpolatedSpec	"{\S*}" contained
syn region  csString		start=+"+  end=+"+ end=+$+ contains=csSpecialChar,csSpecialError,csUnicodeNumber,@Spell
syn match   csCharacter		"'[^']*'" contains=csSpecialChar,csSpecialCharError
syn match   csCharacter		"'\\''" contains=csSpecialChar
syn match   csCharacter		"'[^\\]'"
syn match   csNumber		"\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match   csNumber		"\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match   csNumber		"\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match   csNumber		"\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

syn region  csQuiet	start=+_logger.[Debug|BulkDebug|Info].*$"+ end=+")+ skip=+""+ contains=csInterpolatedSpec,@Spell
syn region  csLoud	start=+_logger.[Warning|Error].*$"+ end=+")+ skip=+""+ contains=csInterpolatedSpec,@Spell

" The default highlighting.
hi def link csType			Type
hi def link csTypeDecleration		Type
hi def link csInterfaceDecleration      Type
hi def link csNewDecleration            Type
hi def link csStorage			Type
hi def link csRepeat			Repeat
hi def link csConditional		Conditional
hi def link csLabel			Label
hi def link csModifier			Type
hi def link csConstant			Constant
hi def link csException			Exception
hi def link csUnspecifiedStatement	Statement
hi def link csUnsupportedStatement	Statement
hi def link csUnspecifiedKeyword	Keyword
hi def link csLinq                      Keyword
hi def link csAsync                     Keyword
hi def link csContextualStatement	Statement
hi def link csOperatorError		Error
hi def link csAttribute			PreProc

hi def link csIface                     Type
hi def link csClass                     Type

hi def link csTodo			Todo
hi def link csComment			Comment

hi def link csSpecialError		Error
hi def link csSpecialCharError		Error
hi def link csString			String
hi def link csVerbatimString		String
hi def link csVerbatimSpec		SpecialChar

hi def link csInterpolatedString		String
hi def link csInterpolatedSpec		SpecialChar
hi def link csPreCondit			PreCondit
hi def link csCharacter			Character
hi def link csSpecialChar		SpecialChar
hi def link csNumber			Number
hi def link csUnicodeNumber		SpecialChar
hi def link csUnicodeSpecifier		SpecialChar
hi def link csTypeOf                    Keyword

" xml markup
hi def link csXmlCommentLeader		Comment
hi def link csXmlComment		Comment
hi def link csXmlTag			Statement

let b:current_syntax = "cs"

let &cpo = s:cs_cpo_save
unlet s:cs_cpo_save

" vim: ts=8
