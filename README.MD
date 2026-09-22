# CCMM and DataCite: Crosswalks and Transformations

This repository contains materials related to the **mutual mapping** and **transformation** between **CCMM** and **DataCite** metadata standards, including the technical XSLT transformation scripts.

> ⚠️ **Work in Progress:** Currently updating mappings and transformations to support CCMM v2.0.0.

> [!IMPORTANT]
> This XSLT transformation is subject to minor ongoing improvements. While it is fully available for custom modification and use, the final responsibility for the transformation results lies with the user. We highly recommend testing and fine-tuning the script against your own datasets to ensure compatibility with specific metadata profiles.

> [!NOTE]
> Changes after 2026-05-14 in XSLT transformations are [logged](./CHANGELOG.MD).

## Introduction

This document describes the background and the methodology for the design of CCMM and DataCite mapping and transformation. The motivation for mapping and transformation between CCMM and DataCite is the need to align CCMM metadata with DataCite metadata and vice versa, i.e., a DataCite-compliant representation of CCMM metadata and a CCMM-compliant representation of DataCite metadata. The need arises because metadata catalogs can support either the CCMM or the DataCite model.

## Background

### CCMM (version 2.0.0)

"The Czech Core Metadata Model for Research Data (abbreviated as CCMM) is a core metadata model for research data description in the Czech Republic, it is an output of the Czech Academic and Research Discovery Services project, hereinafter referred to as CARDS." [https://www.ccmm.cz/en/core-model-ccmm/model-purpose-and-objectives/]

- Web: https://model.ccmm.cz/research-data/en/#Dataset
- XML Schema: https://model.ccmm.cz/research-data/dataset/schema.xsd
- Examples: https://github.com/techlib/CCMM/tree/main/_metadata-samples/xml
- Visualization of the schema along with emphasizing mandatory parts:
![diagram](https://github.com/techlib/CCMM-utils/blob/main/ceCCMM/output/1.1.0/diagram.png)

### DataCite (version 4.7 and 4.6)

"The DataCite Metadata Schema is a list of core metadata properties chosen for accurate and consistent identification of a resource for citation and retrieval purposes, with recommended use instructions in the documentation. The DataCite Metadata Schema is suitable for a wide range of resource types—from samples and images to data and preprints." [https://datacite-metadata-schema.readthedocs.io/en/4.7/introduction/about-schema/] It is currently, one of the most widely used Semantic Web vocabularies for describing datasets and data catalogues.

- Web: https://datacite-metadata-schema.readthedocs.io/en/4.7/
- Examples and XML Schema: https://datacite-metadata-schema.readthedocs.io/en/4.7/xml/
- The XML Schema: https://schema.datacite.org/meta/kernel-4.7/metadata.xsd
- Full Example: https://schema.datacite.org/meta/kernel-4.7/example/datacite-example-full-v4.xml

#### Mandatory elements in DataCite

`\resource\identifier`

`\resource\creators`

`\resource\titles`

`\resource\publisher`

`\resource\publicationYear`

`\resource\resourceType`

## Methodology

CCMM DataCite Mapping and Transformation Methodology is as follows

1. Initial alignment is based on high-level (vocabulary-level) comparison of the metadata elements defined in CCMM 1.1.0 (https://model.ccmm.cz/research-data/en/dsv.ttl) and in DataCite in-house vocabulary representation in OWL (https://model.ccmm.cz/vocabulary/datacite/model.owl.ttl)

2. XML crosswalks

    2.1. XML crosswalks based on sample examples for CCMM metadata and DataCite metadata (initial mappings).

    2.2. XML crosswalks (exhaustive mappings using the full list of elements and attributes for CCMM and DataCite)

3. Operationalize XML crosswalks using XSLT transformation, aiming at transforming metadata:

    3.1. CCMM metadata to DataCite metadata, i.e., DataCite-compliant representation of CCMM metadata

    3.2. DataCite metadata to CCMM metadata, i.e., CCMM-compliant representation of DataCite metadataa

The whole approach is iterative.

## Vocabulary-level CCMM DataCite Mapping

Documented in the initial-mapping branch.

## XML-level crosswalks

Partly documented in the initial-mapping branch.

### 2.2. XML crosswalks -- an exhaustive mapping

Once the initial mapping and XML crosswalks were completed, we shifted to an exhaustive search that began with DataCite elements and attributes (queried via XPath) to identify the corresponding CCMM nodes.

> [!NOTE]
> Currently, XML crosswalks are not uptodate with XSLT transformations. It will be updated.

Complete list of [XML crosswalks in one table](./mappings/DataCite-from-CCMM-XML-crosswalks.md) or in [TSV file](./mappings/DataCite-from-CCMM-XML-crosswalks.tsv)


## 3. XSLT transformation

Operationalize XML crosswalks using XSLT transformation aiming at transforming metadata:

- [XSLT transformation](./mappings/transformation-datacite-from-ccmm.xsl) for transforming **CCMM metadata to DataCite metadata**, i.e. DataCite-compliant representation of CCMM metadata

- [XSLT transformation](./mappings/transformation-ccmm-from-datacite.xsl) for transforming **DataCite metadata to CCMM metadata**, i.e. CCMM-compliant representation of DataCite metadata


## 4. Testing

### 4.1 CCMM XML samples

For validating the XSLT transformation workflow, we employ round‑tripping tests, ensuring that the transformed output can be converted back to its original form:

```
+-----------------+        XSLT        +------------------+
|  CCMM XML (in)  |  ----------------> |  DataCite XML    |
+-----------------+                    +------------------+
                                             |
                                             |  XSLT
                                             v
                                       +------------------+
                                       | CCMM XML (out)  |
                                       +------------------+
```

| CCMM XML input                                                                 | DataCite XML output                                                                      | CCMM XML output                                                                               |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| [dataset-mini.xml](./metadata-samples-test/dataset-mini.xml)                   | [dataset-mini-datacite.xml](./metadata-samples-test/dataset-mini-datacite.xml)           | [dataset-mini-datacite-back.xml](./metadata-samples-test/dataset-mini-datacite-back.xml)       |
| [ccmm_sample.xml](./metadata-samples-test/ccmm_sample.xml)                     | [ccmm_sample-datacite.xml](./metadata-samples-test/ccmm_sample-datacite.xml)             | [ccmm_sample-datacite-back.xml](./metadata-samples-test/ccmm_sample-datacite-back.xml)         |
| [1m3t2-78951.xml](./metadata-samples-test/1m3t2-78951.xml)                     | [1m3t2-78951-datacite.xml](./metadata-samples-test/1m3t2-78951-datacite.xml)             | [1m3t2-78951-datacite-back.xml](./metadata-samples-test/1m3t2-78951-datacite-back.xml)         |
| [dmq82-ed856.xml](./metadata-samples-test/dmq82-ed856.xml)                     | [dmq82-ed856-datacite.xml](./metadata-samples-test/dmq82-ed856-datacite.xml)             | [dmq82-ed856-datacite-back.xml](./metadata-samples-test/dmq82-ed856-datacite-back.xml)         |


### 4.2 Real DataCite metadata records

Using https://oai.datacite.org/oai the following real DataCite metadata records have been gathered for XSLT transformation testing:

#### **subset01-DataCite-4.6**

15 "randomly" selected DataCite metadata files (v 4.6) out of 17500 DataCite metadata records.

> [!NOTE]
> Not updated for new verion yet.

#### **subset01-DataCite-4.5**


15 "randomly" selected DataCite metadata files (v 4.5) out of 1650 DataCite metadata records.

> [!NOTE]
> Not updated for new verion yet.

#### **subset01-DataCite-4.4**

15 "randomly" selected DataCite metadata files (v 4.4) out of 750 DataCite metadata records.

> [!NOTE]
> Not updated for new verion yet.

<!--
## Transformation Issues and Further Notes

in progress-->

## Current actions
- Mapping between DataCite controlled vocabularies and CCMM controlled vocabularies in both directions, with application in XSLT transformations. Mapping of resource types from DataCite to COAR has already been implemented; mapping from COAR to DataCite is currently in progress. At present, values from controlled vocabularies are otherwise taken directly from the source metadata within the XSLT transformations.
- We work on mappings and transformations for CCMM version 2.0.0.
- We work on RDF layer and its corresponding mappings and transformations.

