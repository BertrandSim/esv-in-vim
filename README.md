## Plugin
esv-in-vim: Read the ESV Bible in vim. 
Enter a Bible reference via the command line, or view an existing reference in a vim window.

## Requirements

- Vim, with python3 support
- An ESV API key; get one [here](https://api.esv.org/account/create-application/)

## Usage
vim-in-esv provides an 'ESV' command, and an operator mapping. Both can be used to view a passage reference of choice.

To use the 'ESV' command, enter 
```
:ESV *passage reference*
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
For details what references are supported, refer to the [ESV API webpage](https://api.esv.org/docs/passage-text/).

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

2. Paste your ESV API key in the file `esv_api_key` (do not include any quotes).

## Customizing
The operator mapping is bound to `<Leader>bb` by default. To change this, provide a mapping to `<Plug>(esv-in-vim)`. For example, if you wish to use `gb` (short for "get-bible") instead, add
```
nmap gb <Plug>(esv-in-vim)
vmap gb <Plug>(esv-in-vim)
```
to your vimrc.

window splits options: [TODO]

## Contributing
[TODO]


