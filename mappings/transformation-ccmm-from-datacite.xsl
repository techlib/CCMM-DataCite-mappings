<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="https://schema.ccmm.cz/research-data/1.1"
    xmlns:dc="http://datacite.org/schema/kernel-4"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dc">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:variable name="reverseLicenseMap">
        <entry id="CC-BY-4.0" name="Creative Commons Attribution 4.0 International" />
        <entry id="CC-BY-SA-4.0" name="Creative Commons Attribution-ShareAlike 4.0 International" />
        <entry id="CC-BY-ND-4.0" name="Creative Commons Attribution-NoDerivatives 4.0 International" />
        <entry id="CC-BY-NC-4.0" name="Creative Commons Attribution-NonCommercial 4.0 International" />
    </xsl:variable>

    <xsl:template match="/dc:resource">
        <dataset xsi:schemaLocation="https://schema.ccmm.cz/research-data/1.1 https://model.ccmm.cz/research-data/1.1.0/dataset/schema.xsd">
            <iri>
                <xsl:value-of select="concat('https://doi.org/', dc:identifier)"/>
            </iri>
            
            <metadata_identification>
<!--                    <xsl:apply-templates select="dc:contributors/dc:contributor[@contributorType='DataManager']" mode="back_to_ccmm"/>-->
                <xsl:apply-templates
                    select="dc:contributors/dc:contributor[
                    @contributorType='DataManager' 
                    or @contributorType='ContactPerson' 
                    or @contributorType='DataCurator'
                    ]" 
                    mode="back_to_ccmm"/>
                
<!--                if there is no DataManager and at the same time we can find publisher-->
                <xsl:if test="not(dc:contributors/dc:contributor[@contributorType='DataManager']) and dc:publisher">
                    <xsl:apply-templates select="dc:publisher" mode="back_to_ccmm">
                        <xsl:with-param name="forcedRole"
                            select="'https://schema.ccmm.cz/vocabulary/role/DataManager'"/>
                    </xsl:apply-templates>
                </xsl:if>
                
                <conforms_to_standard>
                    <iri>https://schema.ccmm.cz/research-data/1.1.0</iri>
                    <label xml:lang="">CCMM RD 1.1.0</label>
                </conforms_to_standard>
                
                <xsl:choose>
                    <!-- Priority 1: IsVariantFormOf -->
                    <xsl:when test="dc:relatedIdentifiers/dc:relatedIdentifier[@relationType='IsVariantFormOf']">
                        <original_repository>
                            <iri>
                                <xsl:value-of
                                    select="dc:relatedIdentifiers/dc:relatedIdentifier[@relationType='IsVariantFormOf'][1]"/>
                            </iri>
                        </original_repository>
                    </xsl:when>
                    
                    <!-- Prirority 2: DOI -->
                    <xsl:when test="dc:identifier[@identifierType='DOI']">
                        <original_repository>
                            <iri>
                                <xsl:value-of
                                    select="concat('https://doi.org/', normalize-space(dc:identifier[@identifierType='DOI'][1]))"/>
                            </iri>
                        </original_repository>
                    </xsl:when>
                </xsl:choose>
            </metadata_identification>
            
            <xsl:apply-templates select="dc:identifier | dc:alternateIdentifiers/dc:alternateIdentifier"/>

            <xsl:if test="dc:version"><version><xsl:value-of select="dc:version"/></version></xsl:if>

            <title>
<!--            <xsl:if test="dc:titles/dc:title[not(@titleType)]/@xml:lang">
                    <xsl:attribute name="xml:lang" select="dc:titles/dc:title[not(@titleType)]/@xml:lang"/>
                </xsl:if>
-->             
                <xsl:value-of select="dc:titles/dc:title[not(@titleType)][1]"/>
            </title>

            <xsl:for-each select="dc:titles/dc:title[@titleType]">
                <alternate_title>
                    <title>
                        <xsl:if test="@xml:lang"><xsl:attribute name="xml:lang" select="@xml:lang"/></xsl:if>
                        <xsl:value-of select="."/>
                    </title>
                    <alternate_title_type>
                        <iri><xsl:value-of select="concat('https://schema.ccmm.cz/vocabulary/titleType/', @titleType)"/></iri>
                    </alternate_title_type>
                </alternate_title>
            </xsl:for-each>

            <xsl:apply-templates select="dc:creators/dc:creator" mode="back_to_ccmm"/>
            <xsl:apply-templates select="dc:contributors/dc:contributor" mode="back_to_ccmm"/>
            <xsl:apply-templates select="dc:publisher" mode="back_to_ccmm"/>

            <publication_year><xsl:value-of select="dc:publicationYear"/></publication_year>

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
                                        <date><xsl:value-of select="normalize-space(substring-before(., '/'))"/></date>
                                    </beginning>
                                    <end>
                                        <date><xsl:value-of select="normalize-space(substring-after(., '/'))"/></date>
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
                                                    "/>
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
                        <iri><xsl:value-of select="concat('https://schema.ccmm.cz/vocabulary/dateType/', @dateType)"/></iri>
                    </date_type>
                </time_reference>
            </xsl:for-each>
            
            <xsl:if test="not(dc:resourceType/@resourceTypeGeneral = 'Dataset')">
                <xsl:message>
                    Warning: CCMM schema is intended for resources of type 'Dataset'. The current resource type is '<xsl:value-of select="dc:resourceType/@resourceTypeGeneral"/>'.
                </xsl:message>
            </xsl:if>
            
            
            <resource_type>
                <iri>http://purl.org/coar/resource_type/c_ddb1</iri>
                <label xml:lang="en"><xsl:value-of select="dc:resourceType"/></label>
            </resource_type>

            <xsl:if test="dc:language">
                <primary_language>
                    <iri><xsl:value-of select="concat('https://schema.ccmm.cz/vocabulary/language/', dc:language)"/></iri>
                </primary_language>
            </xsl:if>

            <terms_of_use>
                <xsl:for-each select="dc:rightsList/dc:rights[
                    not(
                    @rightsIdentifier 
                    or contains(lower-case(@rightsURI), 'license')
                    or contains(lower-case(@rightsURI), 'creativecommons')
                    or matches(lower-case(.), 'license|licence|gpl|agpl|mit|cc-|apache|bsd|©|copyright')
                    )
                    ]">
                    
                    <access_rights>
                        <xsl:if test="@rightsURI">
                            <iri><xsl:value-of select="@rightsURI"/></iri>
                        </xsl:if>
                        <label xml:lang="en">
                            <xsl:value-of select="normalize-space(.)"/>
                        </label>
                        <xsl:if test="lower-case(normalize-space(.)) = 'open access'">
                            <label xml:lang="cs">otevřený přístup</label>
                        </xsl:if>
                    </access_rights>
                </xsl:for-each>
                
                <xsl:for-each select="dc:rightsList/dc:rights[
                    @rightsIdentifier 
                    or contains(lower-case(@rightsURI), 'license')
                    or contains(lower-case(@rightsURI), 'creativecommons')
                    or matches(lower-case(.), 'license|licence|gpl|agpl|mit|cc-|apache|bsd|©|copyright')
                    ]">
                    <license>
                        <xsl:if test="@rightsURI">
                            <iri><xsl:value-of select="@rightsURI"/></iri>
                        </xsl:if>
                        <label xml:lang="en">
                            <xsl:variable name="rId" select="@rightsIdentifier"/>
                            <xsl:choose>
                                <xsl:when test="$rId">
                                    <xsl:value-of select="($reverseLicenseMap/entry[@id=$rId]/@name, normalize-space(.))[1]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </label>
                    </license>
                </xsl:for-each>
            </terms_of_use>
            
            <xsl:for-each select="dc:subjects/dc:subject">
                <subject>
                    <xsl:if test="@valueURI"><iri><xsl:value-of select="@valueURI"/></iri></xsl:if>
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
                    <xsl:if test="@subjectScheme">
                        <subject_scheme>
                            <xsl:if test="@schemeURI"><iri><xsl:value-of select="@schemeURI"/></iri></xsl:if>
                            <label xml:lang="en"><xsl:value-of select="@subjectScheme"/></label>
                        </subject_scheme>
                    </xsl:if>
                </subject>
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
                        <iri><xsl:value-of select="concat('https://schema.ccmm.cz/vocabulary/descriptionType/', @descriptionType)"/></iri>
                    </description_type>
                </description>
            </xsl:for-each>

            <xsl:for-each select="dc:geoLocations/dc:geoLocation">
                <location>
                    <xsl:if test="dc:geoLocationBox">
                        <bounding_box>
                            <gml:lowerCorner><xsl:value-of select="concat(dc:geoLocationBox/dc:southBoundLatitude, ' ', dc:geoLocationBox/dc:westBoundLongitude)"/></gml:lowerCorner>
                            <gml:upperCorner><xsl:value-of select="concat(dc:geoLocationBox/dc:northBoundLatitude, ' ', dc:geoLocationBox/dc:eastBoundLongitude)"/></gml:upperCorner>
                        </bounding_box>
                    </xsl:if>
                    <xsl:if test="dc:geoLocationPlace"><name><xsl:value-of select="dc:geoLocationPlace"/></name></xsl:if>
                    <xsl:if test="dc:geoLocationPoint">
                        <geometry>
                            <gml:lowerCorner><xsl:value-of select="concat(dc:geoLocationPoint/dc:pointLongitude, ' ', dc:geoLocationPoint/dc:pointLatitude)"/></gml:lowerCorner>
                        </geometry>
                    </xsl:if>
                    
                    <xsl:variable name="locInfo" select="../../dc:descriptions/dc:description[@descriptionType='TechnicalInfo'][starts-with(., 'LocName:')][contains(., concat('LocName: ', current()/dc:geoLocationPlace))]"/>
                    
                    <xsl:if test="$locInfo">
                        <relation_type>
                            <xsl:variable name="extractedType" select="substring-after($locInfo, 'LocType: ')"/>
                            <iri>
                                <xsl:value-of select="concat('https://schema.ccmm.cz/vocabulary/locationType/', $extractedType)"/>
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
                        <local_identifier><xsl:value-of select="dc:awardNumber"/></local_identifier>                        
                    </xsl:if>
                    <!--                    <xsl:if test="dc:awardNumber/@awardURI"><iri><xsl:value-of select="dc:awardNumber/@awardURI"/></iri></xsl:if>-->
                    <award_title><xsl:value-of select="dc:awardTitle"/></award_title>
                    <funder>
                        <organization>
                            <xsl:if test="dc:funderIdentifier">
                                <iri>
                                    <xsl:choose>
                                        <xsl:when test="dc:funderIdentifier/@funderIdentifierType = 'ROR'">
                                            <xsl:value-of select="concat('https://ror.org/', dc:funderIdentifier)"/>
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
                                            <xsl:when test="dc:funderIdentifier/@funderIdentifierType = 'ROR'">https://ror.org/</xsl:when>
                                            <xsl:when test="dc:funderIdentifier/@funderIdentifierType = 'Crossref Funder ID'">https://www.crossref.org/services/funder-registry/</xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text></xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </iri>
                                    <label xml:lang="">
                                        <xsl:value-of select="dc:funderIdentifier/@funderIdentifierType"/>
                                    </label>
                                </scheme>
                            </identifier>
                            <name><xsl:value-of select="dc:funderName"/></name>
                        </organization>
                    </funder>
                </funding_reference>
            </xsl:for-each>
            
            <xsl:for-each select="dc:relatedItems/dc:relatedItem">
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
                    
                    <xsl:apply-templates select="dc:creators/dc:creator | dc:contributors/dc:contributor" mode="back_to_ccmm"/>
                    
                    <xsl:if test="@relatedItemType">
                        <xsl:variable name="mappingUrl" select="'https://raw.githubusercontent.com/techlib/CCMM-DataCite-mappings/refs/heads/dev/exhaustive-mapping/mappings/resource_mapping_datacite_coar.xml'"/>
                        <xsl:variable name="mapTable" select="document($mappingUrl)"/>
                        
                        <resource_type>
                            <xsl:variable name="dcType" select="@relatedItemType"/>
                            <iri>
                                <xsl:value-of select="$mapTable/mappings/map[@dc = $dcType]/@coar"/>
                            </iri>
                            <label xml:lang="en"><xsl:value-of select="$dcType"/></label>
                        </resource_type>
                    </xsl:if>
                    
<!--                    TODO Apply mapping from DataCite to COAR-->
                    <resource_relation_type>
                        <iri>
                            <xsl:value-of select="concat('https://schema.ccmm.cz/vocabulary/relationType/', @relationType)"/>
                        </iri>
                        <label xml:lang="en"><xsl:value-of select="@relationType"/></label>
                    </resource_relation_type>
                    
                </related_resource>
            </xsl:for-each>
            
            <xsl:if test="dc:formats/dc:format or dc:sizes/dc:size or dc:relatedIdentifiers/dc:relatedIdentifier[@relationType='HasPart' or @relationType='IsReferencedBy']">
                <distribution>
                    <distribution_downloadable_file>
                        <xsl:variable name="info" select="dc:descriptions/dc:description[@descriptionType='TechnicalInfo'][starts-with(., 'DistTitle: ')][1]"/>
                        <title>
                            <xsl:choose>
                                <xsl:when test="contains($info, 'DistTitle: ')">
                                    <xsl:value-of select="substring-after($info, 'DistTitle: ')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="dc:titles/dc:title[1]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </title>
                        
                        <access_url>
                            <iri>
                                <xsl:value-of select="dc:relatedIdentifiers/dc:relatedIdentifier[@relationType='IsDocumentedBy'][1]"/>
                            </iri>
                            <label xml:lang="cs">Informace o přístupu k datům</label>
                        </access_url>
                        
                        <xsl:variable name="downloadUrl" select="dc:relatedIdentifiers/dc:relatedIdentifier[@relationType='HasPart' or @relationType='IsReferencedBy'][1]"/>
                        <xsl:if test="$downloadUrl">
                            <download_url>
                                <iri><xsl:value-of select="$downloadUrl"/></iri>
                                <label xml:lang="en">Data download</label>
                            </download_url>
                        </xsl:if>
                        
                        <format>
                            <xsl:if test="contains($info, 'FormatIRI: ')">
                                <iri>
                                    <xsl:variable name="tmp" select="substring-after($info, 'FormatIRI: ')"/>
                                    <xsl:value-of select="substring-before(concat($tmp, ' |'), ' |')" />
                                </iri>
                            </xsl:if>
                            <label xml:lang="en">
                                <xsl:value-of select="dc:formats/dc:format[1]"/>
                            </label>
                        </format>
                        
                        <xsl:variable name="onlyDigits"
                            select="replace(dc:sizes/dc:size[1], '\D', '')"/>
                        
                        <xsl:if test="$onlyDigits castable as xs:integer">
                            <byte_size>
                                <xsl:value-of select="xs:integer($onlyDigits)"/>
                            </byte_size>
                        </xsl:if>
                    </distribution_downloadable_file>
                </distribution>
            </xsl:if>
            
        </dataset>
    </xsl:template>
    
    <xsl:template match="dc:identifier | dc:alternateIdentifier | dc:relatedItemIdentifier">
        
        <identifier>
            <iri>
                <xsl:variable name="type" select="upper-case((@identifierType, @alternateIdentifierType, @nameIdentifierScheme, @relatedItemIdentifierType)[1])"/>
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
                    <xsl:variable name="type" select="upper-case((@identifierType, @alternateIdentifierType, @nameIdentifierScheme, @relatedItemIdentifierType)[1])"/>
                    <xsl:choose>
                        <!-- either DOI -->
                        <xsl:when test="$type = 'DOI'">https://doi.org</xsl:when>
                        
                        <!-- or something else -->
                        <xsl:when test="starts-with(., 'http')">
                            <xsl:value-of select="concat(tokenize(., '/')[1], '//', tokenize(., '/')[3])"/>
                        </xsl:when>
                        
                        <!-- Fallback -->
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                </iri>
                <label xml:lang="">
                    <xsl:value-of select="(@identifierType, @alternateIdentifierType, @nameIdentifierScheme, @relatedItemIdentifierType)[1]"/>
                </label>
            </scheme>
        </identifier>
        
    </xsl:template>

    <xsl:template match="dc:creator | dc:contributor | dc:publisher" mode="back_to_ccmm">
        
        <xsl:param name="forcedRole" as="xs:string?" />
        
        <qualified_relation>
            <relation>
                <xsl:choose>
                    <xsl:when test="@nameType='Organizational' or self::dc:publisher">
                        <organization>
                            <name><xsl:value-of select="(dc:creatorName, dc:contributorName, .)[1]"/></name>
                            <xsl:if test="dc:affiliation/@affiliationIdentifier">
                                <identifier>
                                    <iri><xsl:value-of select="dc:affiliation/@affiliationIdentifier"/></iri>
                                    <scheme><label><xsl:value-of select="dc:affiliation/@affiliationIdentifierScheme"/></label></scheme>
                                </identifier>
                            </xsl:if>
                        </organization>
                    </xsl:when>
                    <xsl:otherwise>
                        <person>
                            <xsl:apply-templates select="dc:nameIdentifier"/>
                            <name><xsl:value-of select="(dc:creatorName, dc:contributorName)[1]"/></name>
                            <xsl:if test="dc:givenName"><given_name><xsl:value-of select="dc:givenName"/></given_name></xsl:if>
                            <xsl:if test="dc:familyName"><family_name><xsl:value-of select="dc:familyName"/></family_name></xsl:if>
                            <xsl:for-each select="dc:affiliation">
                                <affiliation>
                                    <xsl:if test="@affiliationIdentifier">
                                        <identifier>
                                            <iri><xsl:value-of select="@affiliationIdentifier"/></iri>
                                            <value>
                                                <xsl:value-of select="tokenize(@affiliationIdentifier, '/')[last()]"/>
                                            </value>
                                            <scheme>
                                                <xsl:if test="@schemeURI"><iri><xsl:value-of select="@schemeURI"/></iri></xsl:if>
                                                <label>
                                                    <xsl:attribute name="xml:lang"></xsl:attribute>
                                                    <xsl:value-of select="@affiliationIdentifierScheme"/>
                                                </label>
                                            </scheme>
                                        </identifier>
<!--                                        <name><xsl:value-of select="."/></name>-->
                                    </xsl:if>
<!--                                    use affiliation even if it is not structured-->
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
            </relation>
            <role>
            <iri>
                <xsl:choose>
                    <xsl:when test="$forcedRole">
                        <xsl:value-of select="$forcedRole"/>
                    </xsl:when>
                    <xsl:when test="self::dc:creator">https://schema.ccmm.cz/vocabulary/role/Creator</xsl:when>
                    <xsl:when test="self::dc:publisher">https://schema.ccmm.cz/vocabulary/role/Publisher</xsl:when>
                    <xsl:otherwise><xsl:value-of select="concat('https://schema.ccmm.cz/vocabulary/role/', @contributorType)"/></xsl:otherwise>
                </xsl:choose>
            </iri>
            </role>
        </qualified_relation>
    </xsl:template>

    <xsl:template match="dc:nameIdentifier">
        <identifier>
            <iri><xsl:value-of select="."/></iri>
            <value>
                <xsl:value-of select="tokenize(., '/')[last()]"/>
            </value>
            <scheme>
                <xsl:if test="@schemeURI"><iri><xsl:value-of select="@schemeURI"/></iri></xsl:if>
                <label>
                    <xsl:attribute name="xml:lang"></xsl:attribute>
                    <xsl:value-of select="@nameIdentifierScheme"/>
                </label>
            </scheme>
        </identifier>
    </xsl:template>

</xsl:stylesheet>
