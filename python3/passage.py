#!/usr/bin/env python

# This project takes a passage reference and returns the ESV text for that passage.
# Taken from https://api.esv.org/docs/samples/

# changelog
# 2019-12-29: same as code from https://api.esv.org/docs/samples/
# 2019-12-30: allowed multiple passages, add passage-refs
# 2019-12-31: read API_KEY from external file
# 2020-01-06: read API_KEY from vim global variable (g:__)

import vim
import sys
import requests

# helper func
def get_vim_esv_key():
  vim_enc_save = vim.options['encoding']
  vim.options['encoding'] = 'UTF-8'

  try:
    esv_key = vim.vars['esv_api_key'].decode('UTF-8')
    return esv_key
  except KeyError:
    print("Error while looking for 'g:esv_api_key'")
  finally: 
    vim.options['encoding'] = vim_enc_save


# main
API_KEY = get_vim_esv_key()
# print(API_KEY)
API_URL = 'https://api.esv.org/v3/passage/text/'

def get_esv_text(passage):
    params = {
        'q': passage,
        'include-headings': False,
        'include-footnotes': False,
        'include-verse-numbers': False,
        'include-short-copyright': False,
        'include-passage-references': True,

        'indent-using': 'space',
        'indent-paragraphs': 2,
        'indent-poetry': True,
        'indent-poetry-lines': 4
    }
    if vim.eval("has('conceal')"):
        params['include-verse-numbers'] = True

    headers = {
        'Authorization': 'Token %s' % API_KEY
    }

    response = requests.get(API_URL, params=params, headers=headers)

    passages = response.json()['passages']

    # return passages[0].strip() if passages else 'Error: Passage not found'
    if not passages:
        return 'Error: Passage not found'
    else:
        passages_sep = "\n\n* * *\n\n"
        passages_s = [p.strip() for p in passages]
        return passages_sep.join(passages_s)


# cmd line use: print passage in prompt
if __name__ == '__main__':
    passage = ' '.join(sys.argv[1:])

    if passage:
        print(get_esv_text(passage))
