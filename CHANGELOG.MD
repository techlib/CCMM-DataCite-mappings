# Changelog

---

<br/>

### 2026-09-10
DataCite to CCMM XSLT transformation -- Fix CCMM 1.1.0 transformation issues and add publisherIdentifier:
- Fix duplicate xml:lang attributes by replacing redundant xsl:if with xsl:choose
- Update controlled vocabulary IRIs to match official CCMM 1.1.0 schemes
- Map publisherIdentifier to organizational identifier for dc:publisher

### 2026-05-30
DataCite to CCMM XSLT transformation:
- Fixed a potential schema validation issue by enforcing a mandatory xml:lang attribute on alternative titles. If the source DataCite title lacks a language tag, it now defaults to 'und'.

### 2026-05-22

DataCite to CCMM XSLT transformation:

- Replaced the loop over dc:size elements with a single selection of the first valid numeric value to ensure that byte_size is generated at most once.


### 2026-05-21

DataCite to CCMM XSLT transformation:

- Fixed FormatIRI parsing for end-of-string cases; resolves issue in CCMM → DataCite → CCMM round-trip.

### 2026-05-14

DataCite to CCMM XSLT transformation:

- DataCite copyright goes to CCMM license instead of access rights.
- Dynamic scheme IRI resolution for identifiers: Replaced hardcoded DOI scheme IRI with dynamic resolution.
