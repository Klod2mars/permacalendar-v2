
import zipfile
import os

output_path = r'c:\Users\roman\Documents\apppklod\permacalendarv2\assets\templates\task_template.docx'

# minimal XMLs
content_types = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>"""

rels = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>"""

document_xml = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body>
<w:p><w:r><w:t>Tâche : {{title}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Description : {{description}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Jardin : {{garden}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Parcelle : {{bed}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Date : {{date}} {{time}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Durée : {{duration}} min</w:t></w:r></w:p>
<w:p><w:r><w:t>Type : {{type}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Priorité : {{priority}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Urgent : {{urgent}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Assigné à : {{assignee}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Récurrence : {{recurrence}}</w:t></w:r></w:p>
<w:p><w:r><w:t>Image : {{attachedImage}}</w:t></w:r></w:p>
</w:body>
</w:document>"""

# We need to skip word/_rels/document.xml.rels if we don't have images/styles yet, 
# but usually it's fine to be missing if minimal.
# However, standard docx has it.

with zipfile.ZipFile(output_path, 'w') as zf:
    zf.writestr('[Content_Types].xml', content_types)
    zf.writestr('_rels/.rels', rels)
    zf.writestr('word/document.xml', document_xml)

print(f"Created template at {output_path}")
