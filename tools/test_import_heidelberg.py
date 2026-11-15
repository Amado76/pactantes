"""Regression checks for source typography during Heidelberg extraction."""
import unittest
from types import SimpleNamespace
from unittest.mock import MagicMock, patch

from import_heidelberg import english


def line(text, size=10, font='Times-Roman', top=100):
    return dict(text=text, top=top, chars=[dict(text=c, size=size, fontname=font) for c in text])


class EnglishExtractionTest(unittest.TestCase):
    def test_larger_body_type_is_not_discarded_as_a_heading(self):
        lines = [line('LORD’S DAY 1', font='Helvetica-Bold'),
                 line('1. Q. First line'), line('second line?'),
                 line('A. First answer line.'), line('Remaining answer text.'),
                 line('The First Part', font='Times-Bold'),
                 line('OUR SIN AND MISERY', 12, 'Helvetica-Bold')]
        for number in range(2, 130):
            lines.extend([line(f'{number}. Q. Question?', 9), line('A. Answer.', 9)])
        pdf = MagicMock()
        pdf.__enter__.return_value.pages = [SimpleNamespace(extract_text_lines=lambda **kwargs: lines)]
        with patch('import_heidelberg.pdfplumber.open', return_value=pdf):
            rows = english('fixture.pdf')
        self.assertEqual(rows[0]['question'], 'First line second line?')
        self.assertEqual(rows[0]['answer'], 'First answer line. Remaining answer text.')
        self.assertEqual(len(rows), 129)


if __name__ == '__main__':
    unittest.main()
