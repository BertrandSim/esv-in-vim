#!/usr/bin/env python

# This project prints a random verse from the book of Proverbs.
# Taken from https://api.esv.org/docs/samples/

import re
import random
import requests


API_KEY = '0749a4bce8ef6fc9c3cd2c96a68f98b0efd230a4'
API_URL = 'https://api.esv.org/v3/passage/text/'

CHAPTER_LENGTHS = [
    33, 22, 35, 27, 23, 35, 27, 36, 18, 32,
    31, 28, 25, 35, 33, 33, 28, 24, 29, 30,
    31, 29, 35, 34, 28, 28, 27, 28, 27, 33,
    31
]


def get_passage():
    chapter = random.randrange(1, len(CHAPTER_LENGTHS))
    verse = random.randint(1, CHAPTER_LENGTHS[chapter])

    return 'Proverbs %s:%s' % (chapter, verse)


def get_esv_text(passage):
    params = {
        'q': passage,
        'indent-poetry': False,
        'include-headings': False,
        'include-footnotes': False,
        'include-verse-numbers': False,
        'include-short-copyright': False,
        'include-passage-references': False
    }

    headers = {
        'Authorization': 'Token %s' % API_KEY
    }

    data = requests.get(API_URL, params=params, headers=headers).json()

    text = re.sub('\s+', ' ', data['passages'][0]).strip()

    return '%s – %s' % (text, data['canonical'])


def render_esv_text(data):
    text = re.sub('\s+', ' ', data['passages'][0]).strip()

    return '%s – %s' % (text, data['canonical'])


# cmd line use: print proverb in prompt
if __name__ == '__main__':
    print(get_esv_text(get_passage()))
