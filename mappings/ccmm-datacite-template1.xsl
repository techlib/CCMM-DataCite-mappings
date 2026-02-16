<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ccmm="https://schema.ccmm.cz/research-data/1.1"
    xmlns:datacite="http://datacite.org/schema/kernel-4"
    exclude-result-prefixes="ccmm">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/ccmm:dataset">
        <resource xmlns="http://datacite.org/schema/kernel-4"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://datacite.org/schema/kernel-4 https://schema.datacite.org/meta/kernel-4/metadata.xsd">

            <identifier identifierType="DOI">
                <xsl:value-of select="ccmm:identifier[ccmm:scheme/ccmm:label='DOI']/ccmm:value"/>
            </identifier>

            <creators>
                <xsl:for-each select="ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en']='Creator']">
                    <creator>
                        <creatorName>
                            <xsl:value-of select="ccmm:relation/ccmm:person/ccmm:family_name"/>, <xsl:value-of select="ccmm:relation/ccmm:person/ccmm:given_name"/>
                        </creatorName>
                    </creator>
                </xsl:for-each>
            </creators>

            <titles>
                <title xml:lang="cs"><xsl:value-of select="ccmm:title"/></title>
            </titles>

            <publisher>
                <xsl:value-of select="ccmm:qualified_relation[ccmm:role/ccmm:label[@xml:lang='en']='Publisher']/ccmm:relation/ccmm:person/ccmm:affiliation/ccmm:name"/>
            </publisher>

            <publicationYear>
                <xsl:value-of select="ccmm:publication_year"/> </publicationYear>

            <subjects>
                <xsl:for-each select="ccmm:subject"> <subject>
                        <xsl:if test="ccmm:classification_code">
                            <xsl:attribute name="classificationCode">
                                <xsl:value-of select="ccmm:classification_code"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="ccmm:title[@xml:lang='en']"/>
                    </subject>
                </xsl:for-each>
            </subjects>

            <dates>
                <xsl:if test="ccmm:metadata_identification/ccmm:date_updated">
                    <date dateType="Updated">
                        <xsl:value-of select="ccmm:metadata_identification/ccmm:date_updated"/> </date>
                </xsl:if>
                <xsl:if test="ccmm:metadata_identification/ccmm:date_created">
                    <date dateType="Created">
                        <xsl:value-of select="ccmm:metadata_identification/ccmm:date_created"/> </date>
                </xsl:if>
            </dates>

            <resourceType resourceTypeGeneral="Dataset">
                <xsl:value-of select="ccmm:resource_type/ccmm:label[@xml:lang='en']"/>
            </resourceType>

            <rightsList>
                <xsl:for-each select="ccmm:terms_of_use/ccmm:license"> <rights>
                        <xsl:attribute name="rightsURI">
                            <xsl:value-of select="ccmm:iri"/>
                        </xsl:attribute>
                        <xsl:value-of select="ccmm:label[@xml:lang='en']"/>
                    </rights>
                </xsl:for-each>
            </rightsList>

            <descriptions>
                <xsl:for-each select="ccmm:description"> <description>
                        <xsl:attribute name="descriptionType">
                            <xsl:value-of select="ccmm:description_type/ccmm:label[@xml:lang='en']"/>
                        </xsl:attribute>
                        <xsl:value-of select="ccmm:description_text"/>
                    </description>
                </xsl:for-each>
            </descriptions>

            <geoLocations>
                <xsl:for-each select="ccmm:location"> <geoLocation>
                        <geoLocationPlace><xsl:value-of select="ccmm:name"/></geoLocationPlace>
                    </geoLocation>
                </xsl:for-each>
            </geoLocations>

            <fundingReferences>
                <xsl:for-each select="ccmm:funding_reference"> <fundingReference>
                        <funderName>
                            <xsl:value-of select="ccmm:funder/ccmm:organization/ccmm:name"/>
                        </funderName>
                        <funderIdentifier funderIdentifierType="ROR">
                            <xsl:value-of select="ccmm:funder/ccmm:organization/ccmm:identifier/ccmm:value"/>
                        </funderIdentifier>
                        <awardNumber>
                            <xsl:value-of select="ccmm:local_identifier"/>
                        </awardNumber>
                        <awardTitle>
                            <xsl:value-of select="ccmm:award_title"/>
                        </awardTitle>
                    </fundingReference>
                </xsl:for-each>
            </fundingReferences>

        </resource>
    </xsl:template>

</xsl:stylesheet>
