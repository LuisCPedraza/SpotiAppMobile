import pypdf
import os
import re

pdf_path = os.path.join('docs', 'Taller spotify.pdf')
txt_path = os.path.join('docs', 'taller_spotify_extracted.txt')

def extract_text():
    try:
        reader = pypdf.PdfReader(pdf_path)
        all_text = []
        for page in reader.pages:
            all_text.append(page.extract_text() or '')
        
        full_content = '\n'.join(all_text)
        
        with open(txt_path, 'w', encoding='utf-8') as f:
            f.write(full_content)
        
        print(f'Total pages: {len(reader.pages)}')
        
        # Cleaned preview (ASCII safe)
        preview = full_content[:1200]
        preview_clean = preview.encode('ascii', 'ignore').decode('ascii')
        print('--- PREVIEW (First 1200 chars) ---')
        print(preview_clean)
        print('----------------------------------')
        
        # Detect headers
        print('--- DETECTED HEADERS/SECTIONS ---')
        lines = full_content.split('\n')
        for line in lines:
            line = line.strip()
            if not line: continue
            # Lines with ':' or mostly uppercase
            if ':' in line or (line.isupper() and len(line) > 3):
                print(line.encode('ascii', 'ignore').decode('ascii'))
                
    except Exception as e:
        print(f'Error: {e}')

if __name__ == '__main__':
    extract_text()
