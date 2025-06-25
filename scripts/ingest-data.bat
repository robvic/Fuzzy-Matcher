set BUCKET_NAME=data-fuzzy-matcher-280
for %%f in ("..\data\*") do (
    gsutil cp "%%f" gs://%BUCKET_NAME%/
)