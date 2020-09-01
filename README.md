## Plugin
esv-in-vim: Read the ESV Bible in vim. 
Enter a new Bible reference via the command line, or lookup an existing reference via `\bb`.

## Requirements

- Vim, with python3 support
- An ESV API key; get one [here](https://api.esv.org/account/create-application/)

Vim uses the *python requests module* and the *API key* to get passages from [api.esv.org](api.esv.org).

## Usage
vim-in-esv provides an 'ESV' command, and an operator mapping. Both can be used to view a passage reference of choice.

To use the 'ESV' command, enter 
```
:ESV <passage_reference>
```
in the Vim command line.
For example, 
```
:ESV Philippians 4:8
```
Abbreviations of book names are supported, such as
```
:ESV Jn 3:16
```
For details on what references are supported, refer to the [ESV API webpage](https://api.esv.org/docs/passage-text/).

The operator is called with `<Leader>bb` by default. To use it, enter
```
<Leader>bb{motion}
```
in Vim (in normal mode), or 
```
{Visual}<Leader>bb
```
where {motion} or {Visual} contain the passage reference.
For example, suppose that the current window contains the following text:
```
The new heaven and new earth is described in Rev 21.
```
with the cursor on '.'. In normal mode, entering `<Leader>bb2b` or `v2b<Leader>bb` will display the required text.

By default, both methods show the required passage reference in new vertical split window.

## Setup

1. Using your preferred package manager, clone this repo into the required directory.

If you are using Vim's built in package manager, clone this repo into .vim/pack/bundle, ie.
```
cd ~/.vim/pack/bundle
git clone https://github.com/BertrandSim/esv-in-vim.git
```

2. Add your ESV API key to the global variable `g:esv_api_key`. For example, if your key is '0123xxx', add
```
let g:esv_api_key = '0123xxx'
```
in your vimrc. (Your key should be surrounded with quotes.)

## Customizing
The operator mapping is bound to `<Leader>bb` by default. To change this, provide a mapping to `<Plug>(esv-in-vim)`. For example, if you wish to use `gb` (short for "get-bible") instead, add
```
nmap gb <Plug>(esv-in-vim)
vmap gb <Plug>(esv-in-vim)
```
to your vimrc.

window splits options: [TODO]

Text options:

* g:esv_smart_single_quotes (default: 0)
* g:esv_smart_double_quotes (default: 0)

If enabled, smart single quotes `‘`,`’`, and smart double quotes `“`,`”` are preserved in the text.
Otherwise, these are converted to straight quotes `'` and `"` respectively.
## Contributing
Contact me on [github](https://github.com/BertrandSim/esv-in-vim).


