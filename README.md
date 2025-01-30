# Blob Across Companies

A Business Central extension that enables file storage across companies using blob fields.

## Features

- Store files in a shared table accessible across all companies
- Upload any file type using the built-in file picker
- Download stored files
- View file metadata (name, extension, upload date)
- Data is stored in the database using blob fields
- Accessible through the "Blob Storage List" page

## Technical Details

- Table: "Blob Storage" (50100)
  - Configured with `DataPerCompany = false` for cross-company access
  - Uses blob field for file content storage
  - Tracks metadata like filename, extension, and creation date

- Page: "Blob Storage List" (50100)
  - List page with upload/download capabilities
  - Available through role center search
  - Displays file metadata in an easy-to-read format

## Usage

1. Open "Blob Storage List" page
2. To upload:
   - Click "Upload" action
   - Select file from your device
   - File will be stored with metadata
3. To download:
   - Select a file from the list
   - Click "Download" action
   - Choose save location on your device

## Security

- File content is stored with `CustomerContent` data classification
- System metadata uses `SystemMetadata` classification
- All operations are tracked with standard BC logging
