#!/usr/bin/env python3

import sys, os
from bs4 import BeautifulSoup
import tinycss
import urllib.request
from datetime import date

class CodeFinder():
    def __init__(self, path):
        self.path = path
        self.url = 'http://emojipedia.org'

    def getCategories(self):
        print('Getting emoji category list from ' + self.url + '...')
        with urllib.request.urlopen(self.url) as html_doc:
            soup = BeautifulSoup(html_doc, 'html.parser')

        block = soup.find('h2', string='Categories').parent
        categories = []
        for li in block.find_all('li'):
            categories.append((li.a.text[2:], self.url + li.a.get('href')))
        print('Found ' + str(len(categories)) + ' categories.')
        return categories

    def getEmojiCodes(self, url):
        with urllib.request.urlopen(url) as html_doc:
            soup = BeautifulSoup(html_doc, 'html.parser')
        
        codes = []
        emojis = soup.find_all('span', class_='emoji')
        for emojiSpan in soup.find(class_='emoji-list').find_all('span', class_='emoji'):
            emoji = emojiSpan.text
            codelist = []
            for j in range(len(emoji)):
                codepoint = hex(ord(emoji[j]))
                # Filter control charaters
                if not codepoint in ['0xfe0f', '0x200d']:
                    if len(codepoint[2:])==2:
                        codepoint='0x00' + codepoint[2:]
                    codelist.append(codepoint[2:])
            codes.append(codelist)

        codesfinal = []
        for code in codes:
            codesfinal.append('-'.join(code).upper())
        return codesfinal

    # No emojiOne image present for that emoji
    def isMissing(self, code):
        return not os.path.isfile(os.path.join(self.path, 'png', code + '.png'))

    # emojis requiring more than 2 unicode characters cannot 
    # currently be represented in the java source.
    def isTooLong(self, code):
        return len(code.split('-'))>2

    # For now merge some categories so we have five in total.
    def mergeCategories(self):
        print('Merging categories so they fit in Telegram...')
        newlist = []
        newlist.append(self.categorylist[0]) # People
        newlist.append(self.categorylist[1]) # Nature
        newlist.append(self.categorylist[2]) # Food & Drink
        newlist[2] = (newlist[2][0] + ', '  + self.categorylist[3][0], newlist[2][1] + self.categorylist[3][1]) # Celebration
        newlist[2] = (newlist[2][0] + ', '  + self.categorylist[4][0], newlist[2][1] + self.categorylist[4][1]) # Activity
        newlist.append(self.categorylist[5]) # Travel & Places
        newlist[3] = (newlist[3][0] + ', '  + self.categorylist[6][0], newlist[3][1] + self.categorylist[6][1]) # Flags
        newlist.append(self.categorylist[7]) # Travel & Places

        self.categorylist = newlist
        print('New categories are:')
        for cat in self.categorylist:
            print(cat[0], len(cat[1]))

    def getValidCategoriesAndCodes(self):
        categories = self.getCategories()
        self.categorylist = []
        filtered = 0
        empty = []
        for cat in categories:
            print("Getting emojiCodes for '" + cat[0]+ "'...")
            codes = self.getEmojiCodes(cat[1])
            codelist = []
            for code in codes:
                if not self.isMissing(code) and not self.isTooLong(code):
                    codelist.append(code)
                else:
                    filtered += 1
            if len(codelist) > 0:
                self.categorylist.append((cat[0],codelist))
            else:
                empty.append(cat[0])
        print('Filtered ' + str(filtered) + ' unavailable or too long codes.')
        print('Kicked empty categories ' + str(empty) + '.')

    def printEmojiCategoriesAndCodes(self):
        for cat in self.categorylist:
            print(cat[0] + ':')
            for code in cat[1]:
                    print(code)
            print()

class OffsetReader():
    def __init__(self, filename):
        parser = tinycss.make_parser('page3')
        print("Reading file '" + filename + "' to find offsets...")
        self.stylesheet = parser.parse_stylesheet_file(filename)
    
    def getOffsets(self):
        self.offsets = {}
        for i, rule in enumerate(self.stylesheet.rules):
            if i != 0:
                self.offsets[rule.selector[1].as_css()[9:]] = (
                        rule.declarations[0].value[0].content[0].content[0].as_css()[:-2],
                        rule.declarations[0].value[4].content[0].content[0].as_css()[:-2]
                        )
        print('Got all offsets.')

    def printOffsets(self):
        print(self.offsets)

class JavaWriter():
    def __init__(self, categorylist, offsets):
        self.categorylist = categorylist
        self.offsets = offsets
        self.path = 'EmojiData.java'
        self.f = open(self.path, 'w')

    def writeFile(self):
        print("Writing '" + self.path + "'.")
        self.writeJavaHeader()
        self.writeEmojiCodes()
        self.writeOffsets()
        self.writeJavaFooter()
        self.f.close()
        print('Everything DONE!')

    def checkOffsets(self):
        for cat in self.categorylist:
            for code in cat[1]:
                try:
                    self.offsets[code]
                except KeyError:
                    print('Could not find all necessary offsets! Removing some emojis')
                    #TODO: remove corresponding emojicode

    def writeJavaHeader(self):
        self.f.write('/*\n')
        self.f.write(' * Generated by Tools/emojiOne.py on ' + str(date.today()) + '.\n')
        self.f.write(' * You should not change this file manually.\n')
        self.f.write(' */\n')
        self.f.write('\n')
        self.f.write('package org.telegram.messenger;\n')
        self.f.write('\n')
        self.f.write('import java.util.HashMap;\n')
        self.f.write('\n')
        self.f.write('public class EmojiData {\n')

    def writeJavaFooter(self):
        self.f.write('}')
    
    def writeEmojiCodes(self):
        self.f.write(('\tpublic static long[][] data = {\n').expandtabs(4))
        for j, cat in enumerate(self.categorylist):
            self.f.write(('\t\tnew long[]\n').expandtabs(4))
            self.f.write(('\t\t\t{ //' + cat[0] + ', ' + str(len(cat[1])) + '\n').expandtabs(4))
            self.f.write(('\t\t\t\t').expandtabs(4))
            for i, code in enumerate(cat[1]):
                s = self.buildJavaLong(code)
                self.f.write(s)
                if i != len(cat[1])-1:
                    self.f.write(', ')
                if (i+1)%7 == 0:
                    self.f.write(('\n\t\t\t\t').expandtabs(4))
            self.f.write(('\t\t\t\t}\n').expandtabs(4))
            if j != len(self.categorylist)-1:
                self.f.write(', ')
        self.f.write(('\t};\n').expandtabs(4))

    def writeOffsets(self):
        self.f.write(('\tpublic static final HashMap<Long, Integer[]> offsets;\n').expandtabs(4))
        self.f.write(('\tstatic{\n').expandtabs(4))
        self.f.write(('\t\toffsets = new HashMap<>();\n').expandtabs(4))
        for cat in self.categorylist:
            for code in cat[1]:
                l = self.buildJavaLong(code)
                self.f.write(('\t\toffsets.put(' + l + ', new Integer[]{' + self.offsets[code][0] + ',' + self.offsets[code][1] + '});\n').expandtabs(4))
        self.f.write(('\t}\n').expandtabs(4))
    
    # See https://en.wikipedia.org/wiki/UTF-16#U.2B10000_to_U.2B10FFFF
    def buildJavaLong(self, codepointStr):
        codepointlist = codepointStr.split('-')
        hexStr = ''
        for codepointStr in codepointlist:
            codepoint = int(codepointStr,16)
            if codepoint > 0xffff:
                t = codepoint - 0x010000
                high = (t >> 10) + 0xd800
                low = (t & 0b00000000001111111111) + 0xDC00
                hexStr += hex(high)[2:] + hex(low)[2:]
            else:
                hexStr += codepointStr
        hexStr += 'L'
        hexStr = '0x' + hexStr
        return hexStr

if len(sys.argv) != 2:
    sys.exit('Usage: ' + sys.argv[0] + ' ' + '/path/to/emojione/assets/')

path = sys.argv[1]

if not os.path.exists(os.path.join(path, 'png')) or not os.path.exists(os.path.join(path, 'sprites')):
    sys.exit('Could not find png or sprites folders. Are you sure you are in the correct directory?')


finder = CodeFinder(path)
finder.getValidCategoriesAndCodes()
finder.mergeCategories()

reader = OffsetReader(os.path.join(sys.argv[1], 'sprites', 'emojione.sprites.scss'))
reader.getOffsets()

writer = JavaWriter(finder.categorylist, reader.offsets)
writer.checkOffsets()
writer.writeFile()
