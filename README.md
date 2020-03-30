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
`
:ESV <passage_reference>
`
in the Vim command line.
For example, 
```
:ESV Philippians 4:8
```
Abbreviations of book names are supported, such as
```
:ESV Jn 3:16
```

For further details on what reference formats are supported, refer to the [ESV API webpage](https://api.esv.org/docs/passage-text/).

The operator is called with `<Leader>bb` by default. To use it, enter
`
<Leader>bb{motion}
`
in Vim (in normal mode), or 
`
{Visual}<Leader>bb
`
, where {motion} or {Visual} contain the passage reference.
For example, suppose that the current window contains the following text:
```
The new heaven and new earth is described in Rev 21.
```
with the cursor on '.'. In normal mode, entering `<Leader>bb2b` or `v2b<Leader>bb` will display the required text.

By default, both methods show the required passage reference in new vertical split window.

## Multiple Passages
Viewing multiple references can be done in a similar manner described above. This is useful with a list of references. 
As an example, suppose we have the following text in vim:
```
The Bible describes two chief kinds of judgement. They are:
- evaluative judgement (Rom 8:1; 14:10; 2 Cor 5:10; 2 Tim 4:8)
- punitive judgement (Dan 12:1-3; John 5:22-29; Rev 20:11-15)
```
Then with your cursor inside the second pair of parentheses `(...)`, pressing `\bbi)` gives

```
Daniel 12:1–3

  [1] "At that time shall arise Michael, the great prince who has charge of
your people. And there shall be a time of trouble, such as never has been
since there was a nation till that time. But at that time your people shall be
delivered, everyone whose name shall be found written in the book. [2] And
many of those who sleep in the dust of the earth shall awake, some to
everlasting life, and some to shame and everlasting contempt. [3] And those
who are wise shall shine like the brightness of the sky above; and those who
turn many to righteousness, like the stars forever and ever.

* * *

John 5:22–29

  [22] For the Father judges no one, but has given all judgment to the Son,
[23] that all may honor the Son, just as they honor the Father. Whoever does
not honor the Son does not honor the Father who sent him. [24] Truly, truly, I
say to you, whoever hears my word and believes him who sent me has eternal
life. He does not come into judgment, but has passed from death to life.

  [25] "Truly, truly, I say to you, an hour is coming, and is now here, when
the dead will hear the voice of the Son of God, and those who hear will live.
[26] For as the Father has life in himself, so he has granted the Son also to
have life in himself. [27] And he has given him authority to execute judgment,
because he is the Son of Man. [28] Do not marvel at this, for an hour is
coming when all who are in the tombs will hear his voice [29] and come out,
those who have done good to the resurrection of life, and those who have done
evil to the resurrection of judgment.

* * *

Revelation 20:11–15

  [11] Then I saw a great white throne and him who was seated on it. From his
presence earth and sky fled away, and no place was found for them. [12] And I
saw the dead, great and small, standing before the throne, and books were
opened. Then another book was opened, which is the book of life. And the dead
were judged by what was written in the books, according to what they had done.
[13] And the sea gave up the dead who were in it, Death and Hades gave up the
dead who were in them, and they were judged, each one of them, according to
what they had done. [14] Then Death and Hades were thrown into the lake of
fire. This is the second death, the lake of fire. [15] And if anyone's name
was not found written in the book of life, he was thrown into the lake of
fire.
```


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
The operator mapping is bound to `<Leader>bb` by default. To change this, provide a mapping to `<Plug>(esv-in-vim)`. For example, if you wish to use `gb` (short for "get-bible"), add
```
nmap gb <Plug>(esv-in-vim)
vmap gb <Plug>(esv-in-vim)
```
to your vimrc.


Text options:

* g:esv_smart_single_quotes (default: 0)
* g:esv_smart_double_quotes (default: 0)

If enabled, smart single quotes `‘`,`’`, and smart double quotes `“`,`”` are preserved in the text.
Otherwise, these are converted to straight quotes `'` and `"` respectively.

* g:esv_new_split

* g:esv_use_existing

Display options:

* g:esv_autofit (default: 1)

If enabled, hardwraps the scripture text to the width of the current window when references are loaded, or when the window is resized.
If enabled, |esv_in_vim#fitWidth()| is called automatically.

* g:esv_max_width (default: 78)

Maximum allowable width before text is wrapped. Used in |esv_in_vim#fitWidth()|

## Contributing
Contact me through [github](https://github.com/BertrandSim/esv-in-vim).


