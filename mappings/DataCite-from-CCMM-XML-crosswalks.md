| CCMM path | DataCite path |
|-----------|---------------|
| `/resource` | `/ccmm:dataset` |
| `/resource/alternateIdentifiers` | `/ccmm:dataset/ccmm:identifier[ccmm:scheme/ccmm:label != 'DOI']` |
| `/resource/alternateIdentifiers/alternateIdentifier` | `./ccmm:value` |
| `/resource/alternateIdentifiers/alternateIdentifier/@alternateIdentifierType` | `./ccmm:scheme/ccmm:label` |
| `/resource/contributors` | `` |
| `/resource/contributors/contributor` | `/ccmm:dataset/ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en'] != 'Creator' and /ccmm:dataset/ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en'] != 'Publisher'` |
| `/resource/contributors/contributor` | `/ccmm:dataset/ccmm:metadata_information/qualified_relation` |
| `/resource/contributors/contributor/affiliation` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:name` |
| `/resource/contributors/contributor/affiliation/@affiliationIdentifier` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:iri` |
| `/resource/contributors/contributor/affiliation/@affiliationIdentifierScheme` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:scheme/ccmm:label` |
| `/resource/contributors/contributor/affiliation/@schemeURI` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:scheme/ccmm:iri` |
| `/resource/contributors/contributor/contributorName` | `./ccmm:relation/ccmm:person/ccmm:name` |
| `/resource/contributors/contributor/contributorName/@nameType` | `test="ccmm:relation/ccmm:person" Personal or test="ccmm:relation/ccmm:organization" Organizational` |
| `/resource/contributors/contributor/@contributorType` | `./ccmm:role/tokenize(ccmm:iri, ‘/’)[last()]` |
| `/resource/contributors/contributor/familyName` | `./ccmm:relation/ccmm:person/ccmm:family_name` |
| `/resource/contributors/contributor/givenName` | `./ccmm:relation/ccmm:person/ccmm:given_name` |
| `/resource/contributors/contributor/nameIdentifier` | `./ccmm:relation/ccmm:person/ccmm:identifier` |
| `/resource/contributors/contributor/nameIdentifier/@nameIdentifierScheme` | `./ccmm:relation/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:label` |
| `/resource/contributors/contributor/nameIdentifier/@schemeURI` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:scheme/ccmm:iri` |
| `/resource/creators` | `` |
| `/resource/creators/creator` | `/ccmm:dataset/ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en']='Creator']` |
| `/resource/creators/creator/affiliation` | `./ccmm:relation/ccmm:person/ccmm:affiliation` |
| `/resource/creators/creator/affiliation/@affiliationIdentifier` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:iri` |
| `/resource/creators/creator/affiliation/@affiliationIdentifierScheme` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:scheme/ccmm:label` |
| `/resource/creators/creator/affiliation/@schemeURI` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:scheme/ccmm:iri` |
| `/resource/creators/creator/creatorName` | `./ccmm:relation/ccmm:person/ccmm:name` |
| `/resource/creators/creator/creatorName/@nameType` | `test="ccmm:relation/ccmm:person" Personal or test="ccmm:relation/ccmm:organization" Organizational` |
| `/resource/creators/creator/creatorName/@xml:lang` | `ccmm:relation/ccmm:person/ccmm:name/@xml:lang | ccmm:relation/ccmm:organization/ccmm:name/@xml:lang` |
| `/resource/creators/creator/familyName` | `./ccmm:relation/ccmm:person/ccmm:family_name` |
| `/resource/creators/creator/givenName` | `./ccmm:relation/ccmm:person/ccmm:given_name` |
| `/resource/creators/creator/nameIdentifier` | `./ccmm:relation/ccmm:person/ccmm:identifier` |
| `/resource/creators/creator/nameIdentifier/@nameIdentifierScheme` | `./ccmm:relation/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:label` |
| `/resource/creators/creator/nameIdentifier/@schemeURI` | `./ccmm:relation/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:iri` |
| `/resource/dates` | `` |
| `/resource/dates/date` | `/ccmm:dataset/ccmm:time_reference` |
| `/resource/dates/date/@dateType` | `./tokenize(ccmm:date_type/ccmm:iri, '/')[last()]` |
| `/resource/dates/date/@dateInformation` | `` |
| `/resource/language/` | `` |
| `/resource/descriptions` | `` |
| `/resource/descriptions/description` | `/ccmm:dataset/ccmm:description` |
| `/resource/descriptions/description/@descriptionType` | `./tokenize(ccmm:description_type/ccmm:iri, '/')[last()]` |
| `/resource/descriptions/description/@xml:lang` | `./ccmm:description_text/@xml:lang` |
| `/resource/formats` | `` |
| `/resource/formats/format` | `/ccmm:dataset/ccmm:distribution/ccmm:format/ccmm:label` |
| `/resource/fundingReferences` | `` |
| `/resource/fundingReferences/fundingReference` | `/ccmm:dataset/ccmm:funding_reference` |
| `/resource/fundingReferences/fundingReference/awardNumber` | `./ccmm:local_identifier` |
| `/resource/fundingReferences/fundingReference/awardNumber/@awardURI` | `./ccmm:iri` |
| `/resource/fundingReferences/fundingReference/awardTitle` | `./ccmm:award_title` |
| `/resource/fundingReferences/fundingReference/funderIdentifier` | `./ccmm:funder/ccmm:organization/ccmm:identifier/ccmm:iri` |
| `/resource/fundingReferences/fundingReference/funderIdentifier/@funderIdentifierType` | `./ccmm:funder/ccmm:organization/ccmm:identifier/ccmm:scheme/ccmm:iri` |
| `/resource/fundingReferences/fundingReference/funderName` | `./ccmm:funder/ccmm:organization/ccmm:label` |
| `/resource/geoLocations` | `` |
| `/resource/geoLocations/geoLocation` | `/ccmm:dataset/ccmm:location` |
| `/resource/geoLocations/geoLocation/geoLocationBox` | `./ccmm:bounding_box` |
| `/resource/geoLocations/geoLocation/geoLocationBox/eastBoundLongitude` | `tokenize(normalize-space(ccmm:bounding_box/gml:upperCorner), ' ')[1]` |
| `/resource/geoLocations/geoLocation/geoLocationBox/northBoundLatitude` | `tokenize(normalize-space(ccmm:bounding_box/gml:upperCorner), ' ')[1]` |
| `/resource/geoLocations/geoLocation/geoLocationBox/southBoundLatitude` | `tokenize(normalize-space(ccmm:bounding_box/gml:lowerCorner), ' ')[2]` |
| `/resource/geoLocations/geoLocation/geoLocationBox/westBoundLongitude` | `tokenize(normalize-space(ccmm:bounding_box/gml:lowerCorner), ' ')[1]` |
| `/resource/geoLocations/geoLocation/geoLocationPlace` | `./ccmm:name` |
| `/resource/geoLocations/geoLocation/geoLocationPoint` | `./ccmm:geometry/gml:lowerCorner` |
| `/resource/geoLocations/geoLocation/geoLocationPoint/pointLatitude` | `tokenize(normalize-space(ccmm:geometry/gml:lowerCorner), ' ')[1]` |
| `/resource/geoLocations/geoLocation/geoLocationPoint/pointLongitude` | `tokenize(normalize-space(ccmm:geometry/gml:lowerCorner), ' ')[2]` |
| `/resource/geoLocations/geoLocation/geoLocationPolygon` | `./ccmm:geometry/ccmm:wkt` |
| `/resource/geoLocations/geoLocation/geoLocationPolygon/polygonPoint` | `replace(replace($wktContent, 'POLYGON\s*\(\(', ''), '\)\)', '')` |
| `/resource/geoLocations/geoLocation/geoLocationPolygon/polygonPoint/pointLatitude` | `tokenize(normalize-space(.), '\s+')[1]` |
| `/resource/geoLocations/geoLocation/geoLocationPolygon/polygonPoint/pointLongitude` | `tokenize(normalize-space(.), '\s+')[2]` |
| `/resource/identifier` | `/ccmm:dataset/ccmm:identifier[ccmm:scheme/ccmm:label='DOI']/ccmm:value` |
| `/resource/identifier/@identifierType` | `'DOI'` |
| `/resource/publicationYear` | `/ccmm:dataset/ccmm:publication_year` |
| `/resource/publisher` | `/ccmm:dataset/ccmm:qualified_relation[tokenize(ccmm:role/ccmm:iri, '/')[last()] = 'Publisher']/ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:name` |
| `/resource/publisher/@publisherIdentifier` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier` |
| `/resource/publisher/@publisherIdentifierScheme` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:scheme/ccmm:label[@xml:lang='en']` |
| `/resource/publisher/@schemeURI` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:identifier/ccmm:scheme/ccmm:iri` |
| `/resource/publisher/@xml:lang` | `./ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:name/@xml:lang` |
| `/resource/relatedIdentifiers` | `` |
| `/resource/relatedIdentifiers/relatedIdentifier` | `/ccmm:dataset/ccmm:metadata_information/ccmm:original_repository/ccmm:iri` |
| `/resource/relatedIdentifiers/relatedIdentifier/@relatedIdentifierType` | `URL` |
| `/resource/relatedIdentifiers/relatedIdentifier/@relationType` | `IsVariantFormOf` |
| `/resource/relatedIdentifiers/relatedIdentifier/@resourceTypeGeneral` | `Other` |
| `/resource/relatedIdentifiers/relatedIdentifier` | `/ccmm:dataset/ccmm:distribution/ccmm:distribution_downloadable_file/ccmm:download_url/ccmm:iri` |
| `/resource/relatedIdentifiers/relatedIdentifier/@relatedIdentifierType` | `URL` |
| `/resource/relatedIdentifiers/relatedIdentifier/@relationType` | `HasPart` |
| `/resource/relatedIdentifiers/relatedIdentifier/@resourceTypeGeneral` | `Other` |
| `/resource/relatedItems` | `` |
| `/resource/relatedItems/relatedItem` | `/ccmm:dataset/ccmm:related_resource` |
| `/resource/relatedItems/relatedItem/contributors` | `` |
| `/resource/relatedItems/relatedItem/contributors/contributor` | `./ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en'] != 'Creator']` |
| `/resource/relatedItems/relatedItem/contributors/contributor/@contributorType` | `./ccmm:role/tokenize(ccmm:iri, ‘/’)[last()]` |
| `/resource/relatedItems/relatedItem/contributors/contributor/contributorName` | `./ccmm:relation/ccmm:person/ccmm:name` |
| `/resource/relatedItems/relatedItem/contributors/contributor/contributorName/@nameType` | `test="ccmm:relation/ccmm:person" Personal or test="ccmm:relation/ccmm:organization" Organizational` |
| `/resource/relatedItems/relatedItem/contributors/contributor/familyName` | `./ccmm:relation/ccmm:person/ccmm:identifier` |
| `/resource/relatedItems/relatedItem/contributors/contributor/givenName` | `./ccmm:relation/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:label` |
| `/resource/relatedItems/relatedItem/creators` | `` |
| `/resource/relatedItems/relatedItem/creators/creator` | `/ccmm:dataset/ccmm:related_resource/ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en']='Creator']` |
| `/resource/relatedItems/relatedItem/creators/creator/creatorName` | `./ccmm:relation/ccmm:person/ccmm:name` |
| `/resource/relatedItems/relatedItem/creators/creator/creatorName/@nameType` | `test="ccmm:relation/ccmm:person" Personal or test="ccmm:relation/ccmm:organization" Organizational` |
| `/resource/relatedItems/relatedItem/creators/creator/familyName` | `./ccmm:relation/ccmm:person/ccmm:family_name` |
| `/resource/relatedItems/relatedItem/creators/creator/givenName` | `./ccmm:relation/ccmm:person/ccmm:given_name` |
| `/resource/relatedItems/relatedItem/edition` | `` |
| `/resource/relatedItems/relatedItem/firstPage` | `` |
| `/resource/relatedItems/relatedItem/issue` | `` |
| `/resource/relatedItems/relatedItem/lastPage` | `` |
| `/resource/relatedItems/relatedItem/number` | `` |
| `/resource/relatedItems/relatedItem/number/@numberType` | `` |
| `/resource/relatedItems/relatedItem/publicationYear` | `./ccmm:time_reference/ccmm:temporal_representation/ccmm:time_interval/ccmm:beginning/ccmm:date_time or ccmm:time_reference/ccmm:temporal_representation/ccmm:time_instant/ccmm:date` |
| `/resource/relatedItems/relatedItem/publisher` | `./ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en'] = 'Publisher']/ccmm:role/ccmm:label` |
| `/resource/relatedItems/relatedItem/relatedItemIdentifier` | `./ccmm:identifier/ccmm:value` |
| `/resource/relatedItems/relatedItem/relatedItemIdentifier/@relatedItemIdentifierType` | `./ccmm:identifier/ccmm:scheme/ccmm:label` |
| `/resource/relatedItems/relatedItem/@relatedItemType` | `./ccmm:resource_type/ccmm:label[@xml:lang='en']` |
| `/resource/relatedItems/relatedItem/@relationType` | `./ccmm:related_resource/ccmm:resource_relation_type/ccmm:iri` |
| `/resource/relatedItems/relatedItem/titles` | `` |
| `/resource/relatedItems/relatedItem/titles/title` | `/ccmm:dataset/ccmm:related_resource/ccmm:title` |
| `/resource/relatedItems/relatedItem/titles/title` | `/ccmm:dataset/ccmm:related_resource/ccmm:alternate_title` |
| `/resource/relatedItems/relatedItem/titles/title/@titleType` | `tokenize(./ccmm:alternate_title_type/ccmm:iri, ‘/’)[last()]` |
| `/resource/relatedItems/relatedItem/volume` | `` |
| `/resource/resourceType` | `/ccmm:dataset/ccmm:resource_type/ccmm:label[@xml:lang='en']` |
| `/resource/resourceType/@resourceTypeGeneral` | `'Dataset'` |
| `/resource/rightsList` | `/ccmm:dataset/ccmm:terms_of_use/` |
| `/resource/rightsList/rights` | `./ccmm:license` |
| `/resource/rightsList/rights` | `./ccmm:access_rights` |
| `/resource/rightsList/rights/@rightsIdentifier` | `./ccmm:license/ccmm:label TODO conversion to SPDX identifiers is needed` |
| `/resource/rightsList/rights/@rightsIdentifierScheme` | `“SPDX”` |
| `/resource/rightsList/rights/@rightsURI` | `./ccmm:license/ccmm:iri` |
| `/resource/rightsList/rights/@schemeURI` | `https://spdx.org/licenses/` |
| `/resource/rightsList/rights/@xml:lang` | `./ccmm:license/ccmm:label/@xml:lang` |
| `/resource/sizes` | `` |
| `/resource/sizes/size` | `/ccmm:dataset/ccmm:distribution/ccmm:distribution_downloadable_file/ccmm:byte_size` |
| `/resource/subjects` | `` |
| `/resource/subjects/subject` | `/ccmm:dataset/ccmm:subject` |
| `/resource/subjects/subject/title` | `./ccmm:title` |
| `/resource/subjects/subject/@classificationCode` | `./ccmm:classification_code` |
| `/resource/subjects/subject/@schemeURI` | `./ccmm:subject_scheme/ccmm:iri` |
| `/resource/subjects/subject/@subjectScheme` | `./ccmm:subject_scheme/ccmm:label[@xml:lang='en']` |
| `/resource/subjects/subject/@valueURI` | `./ccmm:iri` |
| `/resource/titles` | `` |
| `/resource/titles/title` | `/ccmm:dataset/ccmm:title` |
| `/resource/titles/title` | `/ccmm:dataset/ccmm:alternate_title` |
| `/resource/titles/title/@titleType` | `tokenize(./ccmm:alternate_title_type/ccmm:iri, ‘/’)[last()]` |
| `/resource/titles/title/@xml:lang` | `.-ccmm:title/@xml:lang` |
| `/resource/version` | `/ccmm:dataset/ccmm:version` |
| `/resource/@xsi:schemaLocation` | `"http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.7/metadata.xsd"` |
