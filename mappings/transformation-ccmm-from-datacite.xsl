<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="https://schema.ccmm.cz/research-data/2.0" xmlns:dc="http://datacite.org/schema/kernel-4"
    xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dc">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:variable name="reverseLicenseMap">
        <entry id="CC-BY-4.0" name="Creative Commons Attribution 4.0 International"/>
        <entry id="CC-BY-SA-4.0" name="Creative Commons Attribution-ShareAlike 4.0 International"/>
        <entry id="CC-BY-ND-4.0" name="Creative Commons Attribution-NoDerivatives 4.0 International"/>
        <entry id="CC-BY-NC-4.0" name="Creative Commons Attribution-NonCommercial 4.0 International"
        />
    </xsl:variable>

    <xsl:template match="/dc:resource">
        <dataset
            xsi:schemaLocation="https://schema.ccmm.cz/research-data/2.0 https://raw.githubusercontent.com/techlib/CCMM/refs/heads/2.0.0/dataset/schema.xsd">
            <iri>
                <xsl:value-of select="concat('https://doi.org/', dc:identifier)"/>
            </iri>

            <metadata_identification>
                <!--                    <xsl:apply-templates select="dc:contributors/dc:contributor[@contributorType='DataManager']" mode="back_to_ccmm"/>-->
                <xsl:apply-templates select="
                        dc:contributors/dc:contributor[
                        @contributorType = 'DataManager'
                        or @contributorType = 'ContactPerson'
                        or @contributorType = 'DataCurator'
                        ]" mode="back_to_ccmm"/>

                <!--                if there is no DataManager and at the same time we can find publisher-->
                <xsl:if
                    test="not(dc:contributors/dc:contributor[@contributorType = 'DataManager']) and dc:publisher">
                    <xsl:apply-templates select="dc:publisher" mode="back_to_ccmm">
                        <xsl:with-param name="forcedRole"
                            select="'https://vocabs.ccmm.cz/registry/codelist/AgentRole/Contributor/DataManager'"
                        />
                    </xsl:apply-templates>
                </xsl:if>

                <!--for mandatory data_updated-->
                <xsl:if test="dc:dates/dc:date[@dateType = 'Updated']">
                    <date_updated>
                        <xsl:variable name="val"
                            select="normalize-space(dc:dates/dc:date[@dateType = 'Updated'][1])"/>
                        <xsl:choose>
                            <!-- if xs:dateTime takes only YYYY-MM-DD -->
                            <xsl:when test="contains($val, 'T')">
                                <xsl:value-of select="substring-before($val, 'T')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$val"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </date_updated>
                </xsl:if>

                <!--for optional data_created but it cannot contain comma meaning an interval-->
                <xsl:variable name="createdDate"
                    select="dc:dates/dc:date[@dateType = 'Created'][not(contains(., '/'))][1]"/>
                <xsl:if test="$createdDate">
                    <date_created>
                        <xsl:value-of select="normalize-space($createdDate)"/>
                    </date_created>
                </xsl:if>

                <!--<xsl:if test="dc:dates/dc:date[@dateType='Created']">
                    <date_created>
                        <xsl:variable name="val" select="normalize-space(dc:dates/dc:date[@dateType='Created'][1])"/>
                        <xsl:choose>
                            <xsl:when test="contains($val, 'T')">
                                <xsl:value-of select="substring-before($val, 'T')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$val"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </date_created>
                </xsl:if>-->

                <conforms_to_standard>
                    <iri>https://schema.ccmm.cz/research-data/2.0.0</iri>
                    <label xml:lang="en">Czech Core Metadata Model for Research Data 2.0.0</label>
                </conforms_to_standard>

                <!--CCMM 2.0.0-->
                <!-- search for information about original repository for CCMM record -->
                <xsl:variable name="origRelatedItem" select="
                        dc:relatedItems/dc:relatedItem[
                        dc:titles/dc:title[@titleType = 'Other'] = 'CCMM:OriginalRepository'
                        or @relationType = 'IsVariantFormOf'
                        ][1]"/>

                <xsl:variable name="targetIri">
                    <xsl:choose>

                        <xsl:when test="$origRelatedItem/dc:relatedItemIdentifier">
                            <xsl:value-of
                                select="normalize-space($origRelatedItem/dc:relatedItemIdentifier)"
                            />
                        </xsl:when>

                        <xsl:when test="dc:identifier[@identifierType = 'DOI']">
                            <xsl:value-of
                                select="concat('https://doi.org/', normalize-space(dc:identifier[@identifierType = 'DOI'][1]))"
                            />
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>

                <!-- original_repository -->
                <xsl:if test="string-length($targetIri) > 0">
                    <original_repository>
                        <iri>
                            <xsl:value-of select="$targetIri"/>
                        </iri>

                        <!-- Label (pokud je dostupný v relatedItem) -->
                        <xsl:variable name="itemLabel"
                            select="$origRelatedItem/dc:titles/dc:title[not(@titleType = 'Other')][1]"/>
                        <xsl:if test="$itemLabel">
                            <label>
                                <xsl:if test="$itemLabel/@xml:lang">
                                    <xsl:attribute name="xml:lang">
                                        <xsl:value-of select="$itemLabel/@xml:lang"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$itemLabel"/>
                            </label>
                        </xsl:if>

                        <!-- Description: Získá se z title (pokud existuje jiný než CCMM:OriginalRepository), jinak se vloží defaultní -->
                        <description>
                        
                            <xsl:choose>
                                <!-- Pokud existuje nějaký další titul kromě interního příznaku CCMM:OriginalRepository, použijeme ho jako text popisu -->
                                <xsl:when
                                    test="$origRelatedItem/dc:titles/dc:title[not(@titleType = 'Other')]">
                                    <xsl:if
                                        test="$origRelatedItem/dc:titles/dc:title[not(@titleType = 'Other')][1]/@xml:lang">
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of
                                              select="$origRelatedItem/dc:titles/dc:title[not(@titleType = 'Other')][1]/@xml:lang"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="$origRelatedItem/dc:titles/dc:title[not(@titleType = 'Other')][1]"
                                    />
                                </xsl:when>
                                <!-- Jinak fallback na požadovaný výchozí text -->
                                <xsl:otherwise>
                                    <xsl:attribute name="xml:lang">cs</xsl:attribute>
                                    <xsl:text>Popis repozitáře.</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </description>

                        <!-- Publisher if information available -->
                        <xsl:variable name="itemPublisher" select="$origRelatedItem/dc:publisher"/>
                        <xsl:if test="$itemPublisher">
                            <qualified_attribution>
                                <attributed_agent>
                                    <organization>
                                        <name>
                                            <xsl:value-of select="$itemPublisher"/>
                                        </name>
                                    </organization>
                                </attributed_agent>
                                <role>
                                    <iri>https://vocabs.ccmm.cz/registry/codelist/AgentRole/Publisher</iri>
                                    <label xml:lang="cs">Vydavatel</label>
                                    <label xml:lang="en">Publisher</label>
                                </role>
                            </qualified_attribution>
                        </xsl:if>
                    </original_repository>
                </xsl:if>
            </metadata_identification>

            <xsl:apply-templates
                select="dc:identifier | dc:alternateIdentifiers/dc:alternateIdentifier"/>

            <xsl:if test="dc:version">
                <version>
                    <xsl:value-of select="dc:version"/>
                </version>
            </xsl:if>

            <title>
                <!--            <xsl:if test="dc:titles/dc:title[not(@titleType)]/@xml:lang">
                    <xsl:attribute name="xml:lang" select="dc:titles/dc:title[not(@titleType)]/@xml:lang"/>
                </xsl:if>
-->
                <xsl:value-of select="dc:titles/dc:title[not(@titleType)][1]"/>
            </title>

            <!--If the source DataCite title lacks a language tag, it now defaults to 'und'-->
            <xsl:for-each select="dc:titles/dc:title[@titleType]">
                <alternate_title>
                    <title>
                        <xsl:attribute name="xml:lang">
                            <xsl:choose>
                                <xsl:when test="@xml:lang">
                                    <xsl:value-of select="@xml:lang"/>
                                </xsl:when>
                                <xsl:otherwise>und</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </title>
                    <alternate_title_type>
                        <iri>
                            <xsl:value-of
                                select="concat('https://vocabs.ccmm.cz/registry/codelist/AlternateTitle/', @titleType)"
                            />
                        </iri>
                    </alternate_title_type>
                </alternate_title>
            </xsl:for-each>

            <xsl:apply-templates select="dc:creators/dc:creator" mode="back_to_ccmm"/>
            <xsl:apply-templates select="dc:contributors/dc:contributor" mode="back_to_ccmm"/>
            <xsl:apply-templates select="dc:publisher" mode="back_to_ccmm"/>

            <publication_year>
                <xsl:value-of select="dc:publicationYear"/>
            </publication_year>

            <xsl:for-each select="dc:dates/dc:date">
                <time_reference>
                    <temporal_representation>
                        <xsl:choose>
                            <!--<xsl:when test="contains(., '/')">
                                <time_interval>
                                    <beginning><date><xsl:value-of select="substring-before(., '/')"/></date></beginning>
                                    <end><date><xsl:value-of select="substring-after(., '/')"/></date></end>
                                </time_interval>
                            </xsl:when>-->
                            <!--conversion to xsd:date (ISO 8601)-->
                            <xsl:when test="contains(., '/')">
                                <time_interval>
                                    <beginning>
                                        <date>
                                            <xsl:value-of
                                                select="normalize-space(substring-before(., '/'))"/>
                                        </date>
                                    </beginning>
                                    <end>
                                        <date>
                                            <xsl:value-of
                                                select="normalize-space(substring-after(., '/'))"/>
                                        </date>
                                    </end>
                                </time_interval>
                            </xsl:when>
                            <xsl:otherwise>
                                <time_instant>
                                    <xsl:variable name="val" select="normalize-space(.)"/>

                                    <xsl:choose>

                                        <!-- datetime s mezerou a převod -->
                                        <xsl:when test="matches($val, '^\d{4}-\d{2}-\d{2} ')">
                                            <date_time>
                                                <xsl:value-of select="
                                                        replace(
                                                        replace($val, ' ', 'T'),
                                                        '\.\d+',
                                                        ''
                                                        )
                                                        "
                                                />
                                            </date_time>
                                        </xsl:when>


                                        <!-- xs:dateTime -->
                                        <xsl:when test="matches($val, '^\d{4}-\d{2}-\d{2}T')">
                                            <date_time>
                                                <xsl:value-of select="$val"/>
                                            </date_time>
                                        </xsl:when>

                                        <!-- xs:date -->
                                        <xsl:when test="matches($val, '^\d{4}-\d{2}-\d{2}$')">
                                            <date>
                                                <xsl:value-of select="$val"/>
                                            </date>
                                        </xsl:when>

                                        <!-- YYYY-MM: add day -->
                                        <xsl:when test="matches($val, '^\d{4}-\d{2}$')">
                                            <date>
                                                <xsl:value-of select="concat($val, '-01')"/>
                                            </date>
                                        </xsl:when>

                                        <!-- YYYY: add month and day -->
                                        <xsl:when test="matches($val, '^\d{4}$')">
                                            <date>
                                                <xsl:value-of select="concat($val, '-01-01')"/>
                                            </date>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <date>
                                                <xsl:text>INVALID</xsl:text>
                                            </date>
                                        </xsl:otherwise>

                                    </xsl:choose>
                                </time_instant>
                            </xsl:otherwise>
                        </xsl:choose>
                    </temporal_representation>
                    <date_type>
                        <iri>
                            <xsl:value-of
                                select="concat('https://vocabs.ccmm.cz/registry/codelist/TimeReference/', @dateType)"
                            />
                        </iri>
                    </date_type>
                </time_reference>
            </xsl:for-each>

            <xsl:if test="not(dc:resourceType/@resourceTypeGeneral = 'Dataset')">
                <xsl:message> Warning: CCMM schema is intended for resources of type 'Dataset'. The
                    current resource type is '<xsl:value-of
                        select="dc:resourceType/@resourceTypeGeneral"/>'. </xsl:message>
            </xsl:if>


            <resource_type>
                <iri>http://purl.org/coar/resource_type/c_ddb1</iri>
                <label xml:lang="en">
                    <xsl:value-of select="dc:resourceType"/>
                </label>
            </resource_type>

            <xsl:if test="dc:language">
                <primary_language>
                    <iri>
                        <xsl:value-of
                            select="concat('http://publications.europa.eu/resource/authority/language/', dc:language)"
                        />
                    </iri>
                </primary_language>
            </xsl:if>

            <xsl:for-each select="
                    dc:rightsList/dc:rights[
                    not(
                    @rightsIdentifier
                    or contains(lower-case(@rightsURI), 'license')
                    or contains(lower-case(@rightsURI), 'creativecommons')
                    or matches(lower-case(.), 'license|licence|gpl|agpl|mit|cc-|apache|bsd|©|copyright')
                    )
                    ]">

                <access_rights>
                    <xsl:if test="@rightsURI">
                        <iri>
                            <xsl:value-of select="@rightsURI"/>
                        </iri>
                    </xsl:if>
                    <label xml:lang="en">
                        <xsl:value-of select="normalize-space(.)"/>
                    </label>
                    <xsl:if test="lower-case(normalize-space(.)) = 'open access'">
                        <label xml:lang="cs">otevřený přístup</label>
                    </xsl:if>
                </access_rights>
            </xsl:for-each>

            <xsl:for-each select="dc:subjects/dc:subject">
                <xsl:choose>
                    <!-- should this be subject or keyword - it depends on additional information in dc:subject -->
                    <xsl:when
                        test="@classificationCode or @valueURI or @subjectScheme or @schemeURI">
                        <subject>
                            <xsl:if test="@valueURI">
                                <iri>
                                    <xsl:value-of select="@valueURI"/>
                                </iri>
                            </xsl:if>
                            <title>
                                <xsl:choose>
                                    <xsl:when test="@xml:lang">
                                        <xsl:attribute name="xml:lang" select="@xml:lang"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="."/>
                            </title>
                            <xsl:if test="@classificationCode">
                                <classification_code>
                                    <xsl:value-of select="@classificationCode"/>
                                </classification_code>
                            </xsl:if>
                            <xsl:if test="@subjectScheme">
                                <subject_scheme>
                                    <xsl:if test="@schemeURI">
                                        <iri>
                                            <xsl:value-of select="@schemeURI"/>
                                        </iri>
                                    </xsl:if>
                                    <label xml:lang="en">
                                        <xsl:value-of select="@subjectScheme"/>
                                    </label>
                                </subject_scheme>
                            </xsl:if>
                        </subject>
                    </xsl:when>
                    <!--clear subject without additional information is keyword-->
                    <xsl:otherwise>
                        <xsl:if test="normalize-space(.)">
                            <keyword>
                                <xsl:if test="@xml:lang">
                                    <xsl:attribute name="xml:lang" select="@xml:lang"/>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(.)"/>
                            </keyword>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>

            <xsl:for-each select="dc:descriptions/dc:description">
                <description>
                    <description_text>
                        <xsl:choose>
                            <xsl:when test="@xml:lang">
                                <xsl:attribute name="xml:lang" select="@xml:lang"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="xml:lang">en</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="."/>
                    </description_text>
                    <description_type>
                        <iri>
                            <xsl:value-of
                                select="concat('https://vocabs.ccmm.cz/registry/codelist/DescriptionType/', @descriptionType)"
                            />
                        </iri>
                    </description_type>
                </description>
            </xsl:for-each>

            <xsl:for-each select="dc:geoLocations/dc:geoLocation">
                <location>
                    <xsl:if test="dc:geoLocationBox">
                        <bounding_box>
                            <gml:lowerCorner>
                                <xsl:value-of
                                    select="concat(dc:geoLocationBox/dc:southBoundLatitude, ' ', dc:geoLocationBox/dc:westBoundLongitude)"
                                />
                            </gml:lowerCorner>
                            <gml:upperCorner>
                                <xsl:value-of
                                    select="concat(dc:geoLocationBox/dc:northBoundLatitude, ' ', dc:geoLocationBox/dc:eastBoundLongitude)"
                                />
                            </gml:upperCorner>
                        </bounding_box>
                    </xsl:if>
                    <xsl:if test="dc:geoLocationPlace">
                        <name>
                            <xsl:value-of select="dc:geoLocationPlace"/>
                        </name>
                    </xsl:if>
                    <xsl:if test="dc:geoLocationPoint">
                        <geometry>
                            <gml:lowerCorner>
                                <xsl:value-of
                                    select="concat(dc:geoLocationPoint/dc:pointLongitude, ' ', dc:geoLocationPoint/dc:pointLatitude)"
                                />
                            </gml:lowerCorner>
                        </geometry>
                    </xsl:if>

                    <xsl:variable name="locInfo"
                        select="../../dc:descriptions/dc:description[@descriptionType = 'TechnicalInfo'][starts-with(., 'LocName:')][contains(., concat('LocName: ', current()/dc:geoLocationPlace))]"/>

                    <xsl:if test="$locInfo">
                        <relation_type>
                            <xsl:variable name="extractedType"
                                select="substring-after($locInfo, 'LocType: ')"/>
                            <iri>
                                <xsl:value-of
                                    select="concat('https://vocabs.ccmm.cz/registry/codelist/LocationRelation/', $extractedType)"
                                />
                            </iri>
                            <label xml:lang="en">
                                <xsl:value-of select="$extractedType"/>
                            </label>
                        </relation_type>
                    </xsl:if>
                </location>
            </xsl:for-each>

            <xsl:for-each select="dc:fundingReferences/dc:fundingReference">
                <funding_reference>
                    <xsl:if test="dc:awardNumber">
                        <local_identifier>
                            <xsl:value-of select="dc:awardNumber"/>
                        </local_identifier>
                    </xsl:if>
                    <!--                    <xsl:if test="dc:awardNumber/@awardURI"><iri><xsl:value-of select="dc:awardNumber/@awardURI"/></iri></xsl:if>-->
                    <award_title>
                        <xsl:value-of select="dc:awardTitle"/>
                    </award_title>
                    <funder>
                        <organization>
                            <xsl:if test="dc:funderIdentifier">
                                <iri>
                                    <xsl:choose>
                                        <xsl:when
                                            test="dc:funderIdentifier/@funderIdentifierType = 'ROR'">
                                            <xsl:value-of
                                                select="concat('https://ror.org/', dc:funderIdentifier)"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="dc:funderIdentifier"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </iri>
                            </xsl:if>

                            <identifier>
                                <value>
                                    <xsl:value-of select="dc:funderIdentifier"/>
                                </value>
                                <scheme>
                                    <iri>
                                        <xsl:choose>
                                            <xsl:when
                                                test="dc:funderIdentifier/@funderIdentifierType = 'ROR'"
                                                >https://ror.org/</xsl:when>
                                            <xsl:when
                                                test="dc:funderIdentifier/@funderIdentifierType = 'Crossref Funder ID'"
                                                >https://www.crossref.org/services/funder-registry/</xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </iri>
                                    <label xml:lang="">
                                        <xsl:value-of
                                            select="dc:funderIdentifier/@funderIdentifierType"/>
                                    </label>
                                </scheme>
                            </identifier>
                            <name>
                                <xsl:value-of select="dc:funderName"/>
                            </name>
                        </organization>
                    </funder>
                </funding_reference>
            </xsl:for-each>

            <xsl:for-each select="
                    dc:relatedItems/dc:relatedItem[
                    not(dc:titles/dc:title[@titleType = 'Other'] = 'CCMM:OriginalRepository')
                    ]">
                <related_resource>

                    <xsl:if test="dc:relatedItemIdentifier">
                        <!--<identifier>
                            <value><xsl:value-of select="dc:relatedItemIdentifier"/></value>
                            <scheme>
                                <label xml:lang="en"><xsl:value-of select="dc:relatedItemIdentifier/@relatedItemIdentifierType"/></label>
                            </scheme>
                        </identifier>-->
                        <xsl:apply-templates select="dc:relatedItemIdentifier"/>
                    </xsl:if>

                    <xsl:for-each select="dc:titles/dc:title">
                        <title>
                            <!--<xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang" select="@xml:lang"/>
                            </xsl:if>-->
                            <xsl:value-of select="."/>
                        </title>
                    </xsl:for-each>

                    <xsl:apply-templates
                        select="dc:creators/dc:creator | dc:contributors/dc:contributor"
                        mode="back_to_ccmm"/>

                    <xsl:if test="@relatedItemType">
                        <xsl:variable name="mappingUrl"
                            select="'https://raw.githubusercontent.com/techlib/CCMM-DataCite-mappings/refs/heads/dev/exhaustive-mapping/mappings/resource_mapping_datacite_coar.xml'"/>
                        <xsl:variable name="mapTable" select="document($mappingUrl)"/>

                        <resource_type>
                            <xsl:variable name="dcType" select="@relatedItemType"/>
                            <iri>
                                <xsl:value-of select="$mapTable/mappings/map[@dc = $dcType]/@coar"/>
                            </iri>
                            <label xml:lang="en">
                                <xsl:value-of select="$dcType"/>
                            </label>
                        </resource_type>
                    </xsl:if>

                    <!--                    TODO Apply mapping from DataCite to COAR-->
                    <resource_relation_type>
                        <iri>
                            <xsl:value-of
                                select="concat('https://vocabs.ccmm.cz/registry/codelist/RelationType/', @relationType)"
                            />
                        </iri>
                        <label xml:lang="en">
                            <xsl:value-of select="@relationType"/>
                        </label>
                    </resource_relation_type>

                </related_resource>
            </xsl:for-each>

            <!-- distribitions downloadable file from TECHNICAL INFO -->
            <xsl:for-each
                select="dc:descriptions/dc:description[@descriptionType = 'TechnicalInfo'][starts-with(., 'DistTitle: ')]">
                <xsl:variable name="info" select="."/>
                <distribution>
                    <distribution_downloadable_file>
                        <title>
                            <xsl:variable name="tmp" select="substring-after($info, 'DistTitle: ')"/>
                            <xsl:value-of select="substring-before(concat($tmp, ' |'), ' |')"/>
                        </title>

                        <xsl:if
                            test="/dc:resource/dc:relatedIdentifiers/dc:relatedIdentifier[@relationType = 'IsDocumentedBy']">
                            <access_url>
                                <xsl:value-of
                                    select="/dc:resource/dc:relatedIdentifiers/dc:relatedIdentifier[@relationType = 'IsDocumentedBy'][1]"
                                />
                            </access_url>
                        </xsl:if>

                        <xsl:variable name="downloadUrl"
                            select="/dc:resource/dc:relatedIdentifiers/dc:relatedIdentifier[@relationType = 'HasPart' or @relationType = 'IsReferencedBy'][1]"/>
                        <xsl:if test="$downloadUrl">
                            <download_url>
                                <iri>
                                    <xsl:value-of select="$downloadUrl"/>
                                </iri>
                                <label xml:lang="en">Data download</label>
                            </download_url>
                        </xsl:if>

                        <format>
                            <xsl:if test="contains($info, 'FormatIRI: ')">
                                <iri>
                                    <xsl:variable name="tmp"
                                        select="substring-after($info, 'FormatIRI: ')"/>
                                    <xsl:value-of
                                        select="substring-before(concat($tmp, ' |'), ' |')"/>
                                </iri>
                            </xsl:if>
                            <xsl:if test="/dc:resource/dc:formats/dc:format[1]">
                                <label xml:lang="en">
                                    <xsl:value-of select="/dc:resource/dc:formats/dc:format[1]"/>
                                </label>
                            </xsl:if>
                        </format>

                        <xsl:variable name="onlyDigits"
                            select="replace(/dc:resource/dc:sizes/dc:size[1], '\D', '')"/>
                        <xsl:if test="$onlyDigits castable as xs:integer">
                            <byte_size>
                                <xsl:value-of select="xs:integer($onlyDigits)"/>
                            </byte_size>
                        </xsl:if>

                        <!-- licence for this distribution -->
                        <xsl:if test="contains($info, 'LicenceIRI: ')">
                            <licence>
                                <iri>
                                    <xsl:variable name="tmp"
                                        select="substring-after($info, 'LicenceIRI: ')"/>
                                    <xsl:value-of
                                        select="normalize-space(substring-before(concat($tmp, ' |'), ' |'))"
                                    />
                                </iri>
                            </licence>
                        </xsl:if>
                    </distribution_downloadable_file>
                </distribution>
            </xsl:for-each>

            <!-- distributions data service from TECHNICAL INFO -->
            <xsl:for-each
                select="dc:descriptions/dc:description[@descriptionType = 'TechnicalInfo'][starts-with(., 'ServiceTitle: ')]">
                <xsl:variable name="info" select="."/>

                <!--extracting access url for attribute-->
                <xsl:variable name="serviceUrl">
                    <xsl:if test="contains($info, 'ServiceURL: ')">
                        <xsl:variable name="tmp" select="substring-after($info, 'ServiceURL: ')"/>
                        <xsl:value-of select="substring-before(concat($tmp, ' |'), ' |')"/>
                    </xsl:if>
                </xsl:variable>

                <distribution>
                    <distribution_data_service>
                        <xsl:if test="normalize-space($serviceUrl) != ''"> </xsl:if>

                        <title>
                            <xsl:variable name="tmp"
                                select="substring-after($info, 'ServiceTitle: ')"/>
                            <xsl:value-of select="substring-before(concat($tmp, ' |'), ' |')"/>
                        </title>

                        <!-- licence for this distribtion -->
                        <xsl:if test="contains($info, 'LicenceIRI: ')">
                            <licence>
                                <iri>
                                    <xsl:variable name="tmp"
                                        select="substring-after($info, 'LicenceIRI: ')"/>
                                    <xsl:value-of
                                        select="normalize-space(substring-before(concat($tmp, ' |'), ' |'))"
                                    />
                                </iri>
                            </licence>
                        </xsl:if>
                    </distribution_data_service>
                </distribution>
            </xsl:for-each>

            <!-- backup for distributions if there is no TechnicalInfo information -->
            <xsl:if test="
                    not(dc:descriptions/dc:description[@descriptionType = 'TechnicalInfo'][starts-with(., 'DistTitle: ') or starts-with(., 'ServiceTitle: ')])
                    and (dc:formats/dc:format or dc:sizes/dc:size or dc:relatedIdentifiers/dc:relatedIdentifier[@relationType = 'HasPart' or @relationType = 'IsReferencedBy'])">
                <distribution>
                    <distribution_downloadable_file>
                        <title>
                            <xsl:value-of select="dc:titles/dc:title[1]"/>
                        </title>

                        <xsl:if
                            test="dc:relatedIdentifiers/dc:relatedIdentifier[@relationType = 'IsDocumentedBy']">
                            <access_url>
                                <xsl:value-of
                                    select="dc:relatedIdentifiers/dc:relatedIdentifier[@relationType = 'IsDocumentedBy'][1]"
                                />
                            </access_url>
                        </xsl:if>

                        <xsl:variable name="downloadUrl"
                            select="dc:relatedIdentifiers/dc:relatedIdentifier[@relationType = 'HasPart' or @relationType = 'IsReferencedBy'][1]"/>
                        <xsl:if test="$downloadUrl">
                            <download_url>
                                <iri>
                                    <xsl:value-of select="$downloadUrl"/>
                                </iri>
                                <label xml:lang="en">Data download</label>
                            </download_url>
                        </xsl:if>

                        <xsl:if test="dc:formats/dc:format">
                            <format>
                                <label xml:lang="en">
                                    <xsl:value-of select="dc:formats/dc:format[1]"/>
                                </label>
                            </format>
                        </xsl:if>

                        <xsl:variable name="onlyDigits"
                            select="replace(dc:sizes/dc:size[1], '\D', '')"/>
                        <xsl:if test="$onlyDigits castable as xs:integer">
                            <byte_size>
                                <xsl:value-of select="xs:integer($onlyDigits)"/>
                            </byte_size>
                        </xsl:if>

                        <!-- getting licences from dc:rightsList -->
                        <xsl:for-each select="
                                dc:rightsList/dc:rights[
                                @rightsIdentifier
                                or contains(lower-case(@rightsURI), 'license')
                                or contains(lower-case(@rightsURI), 'creativecommons')
                                or matches(lower-case(.), 'license|licence|gpl|agpl|mit|cc-|apache|bsd|©|copyright')
                                ]">
                            <licence>
                                <xsl:if test="@rightsURI">
                                    <iri>
                                        <xsl:value-of select="@rightsURI"/>
                                    </iri>
                                </xsl:if>
                                <xsl:if test="normalize-space(.)">
                                    <label xml:lang="en">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </label>
                                </xsl:if>
                            </licence>
                        </xsl:for-each>
                    </distribution_downloadable_file>
                </distribution>
            </xsl:if>

        </dataset>
    </xsl:template>

    <xsl:template match="dc:identifier | dc:alternateIdentifier | dc:relatedItemIdentifier">

        <identifier>
            <iri>
                <xsl:variable name="type"
                    select="upper-case((@identifierType, @alternateIdentifierType, @nameIdentifierScheme, @relatedItemIdentifierType)[1])"/>
                <xsl:choose>
                    <xsl:when test="$type = 'DOI' and not(starts-with(., 'http'))">
                        <xsl:value-of select="concat('https://doi.org/', .)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </iri>

            <value>
                <xsl:value-of select="tokenize(., '/')[last()]"/>
            </value>

            <scheme>
                <iri>
                    <xsl:variable name="type"
                        select="upper-case((@identifierType, @alternateIdentifierType, @nameIdentifierScheme, @relatedItemIdentifierType)[1])"/>
                    <xsl:choose>
                        <!-- either DOI -->
                        <xsl:when test="$type = 'DOI'">https://doi.org</xsl:when>

                        <!-- or something else -->
                        <xsl:when test="starts-with(., 'http')">
                            <xsl:value-of
                                select="concat(tokenize(., '/')[1], '//', tokenize(., '/')[3])"/>
                        </xsl:when>

                        <!-- Fallback -->
                        <xsl:otherwise/>
                    </xsl:choose>
                </iri>
                <label xml:lang="">
                    <xsl:value-of
                        select="(@identifierType, @alternateIdentifierType, @nameIdentifierScheme, @relatedItemIdentifierType)[1]"
                    />
                </label>
            </scheme>
        </identifier>

    </xsl:template>

    <xsl:template match="dc:creator | dc:contributor | dc:publisher" mode="back_to_ccmm">

        <xsl:param name="forcedRole" as="xs:string?"/>

        <xsl:variable name="roleType">
            <xsl:choose>
                <xsl:when test="$forcedRole">
                    <xsl:value-of select="$forcedRole"/>
                </xsl:when>
                <xsl:when test="self::dc:creator">Creator</xsl:when>
                <xsl:when test="self::dc:publisher">Publisher</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@contributorType"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <qualified_attribution>
            <attributed_agent>
                <xsl:choose>
                    <xsl:when test="@nameType = 'Organizational' or self::dc:publisher">
                        <organization>

                            <!-- for dc:publisher (DataCite 4.5+) -->
                            <xsl:if test="@publisherIdentifier">
                                <identifier>
                                    <iri>
                                        <xsl:value-of select="@publisherIdentifier"/>
                                    </iri>
                                    <value>
                                        <xsl:value-of
                                            select="tokenize(@publisherIdentifier, '/')[last()]"/>
                                    </value>
                                    <xsl:if test="@publisherIdentifierScheme or @schemeURI">
                                        <scheme>
                                            <xsl:if test="@schemeURI">
                                                <iri>
                                                  <xsl:value-of select="@schemeURI"/>
                                                </iri>
                                            </xsl:if>
                                            <xsl:if test="@publisherIdentifierScheme">
                                                <label xml:lang="en">
                                                  <xsl:value-of select="@publisherIdentifierScheme"
                                                  />
                                                </label>
                                            </xsl:if>
                                        </scheme>
                                    </xsl:if>
                                </identifier>
                            </xsl:if>

                            <!-- for organization defined via dc:affiliation (Creator/Contributor) -->
                            <xsl:if test="dc:affiliation/@affiliationIdentifier">
                                <identifier>
                                    <iri>
                                        <xsl:value-of select="dc:affiliation/@affiliationIdentifier"
                                        />
                                    </iri>
                                    <value>
                                        <xsl:value-of
                                            select="tokenize(dc:affiliation/@affiliationIdentifier, '/')[last()]"
                                        />
                                    </value>
                                    <xsl:if
                                        test="dc:affiliation/@affiliationIdentifierScheme or dc:affiliation/@schemeURI">
                                        <scheme>
                                            <xsl:if test="dc:affiliation/@schemeURI">
                                                <iri>
                                                  <xsl:value-of select="dc:affiliation/@schemeURI"/>
                                                </iri>
                                            </xsl:if>
                                            <xsl:if
                                                test="dc:affiliation/@affiliationIdentifierScheme">
                                                <label xml:lang="en">
                                                  <xsl:value-of
                                                  select="dc:affiliation/@affiliationIdentifierScheme"
                                                  />
                                                </label>
                                            </xsl:if>
                                        </scheme>
                                    </xsl:if>
                                </identifier>
                            </xsl:if>

                            <name>
                                <xsl:value-of select="(dc:creatorName, dc:contributorName, .)[1]"/>
                            </name>

                        </organization>
                    </xsl:when>
                    <xsl:otherwise>
                        <person>
                            <xsl:apply-templates select="dc:nameIdentifier"/>
                            <name>
                                <xsl:value-of select="(dc:creatorName, dc:contributorName)[1]"/>
                            </name>
                            <xsl:if test="dc:givenName">
                                <given_name>
                                    <xsl:value-of select="dc:givenName"/>
                                </given_name>
                            </xsl:if>
                            <xsl:if test="dc:familyName">
                                <family_name>
                                    <xsl:value-of select="dc:familyName"/>
                                </family_name>
                            </xsl:if>
                            <xsl:for-each select="dc:affiliation">
                                <affiliation>
                                    <xsl:if test="@affiliationIdentifier">
                                        <identifier>
                                            <iri>
                                                <xsl:value-of select="@affiliationIdentifier"/>
                                            </iri>
                                            <value>
                                                <xsl:value-of
                                                  select="tokenize(@affiliationIdentifier, '/')[last()]"
                                                />
                                            </value>
                                            <scheme>
                                                <xsl:if test="@schemeURI">
                                                  <iri>
                                                  <xsl:value-of select="@schemeURI"/>
                                                  </iri>
                                                </xsl:if>
                                                <label>
                                                  <xsl:attribute name="xml:lang"/>
                                                  <xsl:value-of
                                                  select="@affiliationIdentifierScheme"/>
                                                </label>
                                            </scheme>
                                        </identifier>
                                    </xsl:if>
                                    <xsl:if test="normalize-space(.)">
                                        <name>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </name>
                                    </xsl:if>
                                </affiliation>
                            </xsl:for-each>
                        </person>
                    </xsl:otherwise>
                </xsl:choose>
            </attributed_agent>
            <role>
                <iri>
                    <xsl:choose>
                        <xsl:when test="starts-with($roleType, 'http')">
                            <xsl:value-of select="$roleType"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="concat('https://schema.ccmm.cz/vocabulary/role/', $roleType)"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </iri>
                <!-- Přidání labelu do role -->
                <label xml:lang="en">
                    <xsl:value-of select="$roleType"/>
                </label>
            </role>
        </qualified_attribution>
    </xsl:template>

    <xsl:template match="dc:nameIdentifier">
        <identifier>
            <iri>
                <xsl:value-of select="."/>
            </iri>
            <value>
                <xsl:value-of select="tokenize(., '/')[last()]"/>
            </value>
            <scheme>
                <xsl:if test="@schemeURI">
                    <iri>
                        <xsl:value-of select="@schemeURI"/>
                    </iri>
                </xsl:if>
                <label>
                    <xsl:attribute name="xml:lang"/>
                    <xsl:value-of select="@nameIdentifierScheme"/>
                </label>
            </scheme>
        </identifier>
    </xsl:template>

</xsl:stylesheet>
