<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ccmm="https://schema.ccmm.cz/research-data/2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns="http://datacite.org/schema/kernel-4"
    exclude-result-prefixes="ccmm">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:variable name="licenseMap">
        <entry name="Creative Commons Attribution 4.0 International" id="CC-BY-4.0" />
        <entry name="Attribution 4.0 International" id="CC-BY-4.0" />
        <entry name="Creative Commons Attribution-ShareAlike 4.0 International" id="CC-BY-SA-4.0" />
        <entry name="Creative Commons Attribution-NoDerivatives 4.0 International" id="CC-BY-ND-4.0" />
        <entry name="Creative Commons Attribution-NonCommercial 4.0 International" id="CC-BY-NC-4.0" />
        <entry name="MIT License" id="MIT" />
        <entry name="Apache License 2.0" id="Apache-2.0" />
    </xsl:variable>    
  
    <xsl:template match="ccmm:qualified_attribution" mode="creator">
        <creator>
            <creatorName>
                <xsl:variable name="lang" select="ccmm:attributed_agent/ccmm:person/ccmm:name/@xml:lang | ccmm:attributed_agent/ccmm:organization/ccmm:name/@xml:lang"/>
                <xsl:if test="$lang">
                    <xsl:attribute name="xml:lang">
                        <xsl:value-of select="$lang"/>
                    </xsl:attribute>
                </xsl:if>                            
                <xsl:attribute name="nameType">
                    <xsl:choose>
                        <xsl:when test="ccmm:attributed_agent/ccmm:person">Personal</xsl:when>
                        <xsl:when test="ccmm:attributed_agent/ccmm:organization">Organizational</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="ccmm:attributed_agent/ccmm:person">
                        <!--concat(ccmm:attributed_agent/ccmm:person/ccmm:family_name, ', ', ccmm:attributed_agent/ccmm:person/ccmm:given_name)-->
                        <xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="ccmm:attributed_agent/ccmm:organization/ccmm:label"/>
                    </xsl:otherwise>
                </xsl:choose>
            </creatorName>
            <xsl:if test="ccmm:attributed_agent/ccmm:person/ccmm:given_name">
                <givenName><xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:given_name"/></givenName>
            </xsl:if>
            <xsl:if test="ccmm:attributed_agent/ccmm:person/ccmm:family_name">
                <familyName><xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:family_name"/></familyName>
            </xsl:if>
            <xsl:if test="ccmm:attributed_agent/ccmm:person/ccmm:identifier">
                <nameIdentifier nameIdentifierScheme="{ccmm:attributed_agent/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:label}" schemeURI="{ccmm:attributed_agent/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:iri}">
                    <xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:identifier/ccmm:iri"/>
                </nameIdentifier>                           
            </xsl:if>
            
            <!--            more affiliation using different identifiers-->
            <xsl:for-each select="ccmm:attributed_agent/ccmm:person/ccmm:affiliation">
                <xsl:variable name="affName" select="ccmm:name"/>
                
                <xsl:choose>
                    <xsl:when test="ccmm:identifier">
                        <xsl:for-each select="ccmm:identifier">
                            <affiliation>
                                <xsl:attribute name="affiliationIdentifier">
                                    <xsl:choose>
                                        <xsl:when test="normalize-space(ccmm:iri)">
                                            <xsl:value-of select="ccmm:iri"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="ccmm:value"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                
                                <xsl:attribute name="affiliationIdentifierScheme">
                                    <xsl:choose>
                                        <xsl:when test="ccmm:scheme/ccmm:notation">
                                            <xsl:value-of select="ccmm:scheme/ccmm:notation"/>
                                        </xsl:when>
                                        <xsl:when test="ccmm:scheme/ccmm:label[@xml:lang='en']">
                                            <xsl:value-of select="ccmm:scheme/ccmm:label[@xml:lang='en']"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>Other</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                
                                <xsl:if test="ccmm:scheme/ccmm:iri">
                                    <xsl:attribute name="schemeURI">
                                        <xsl:value-of select="ccmm:scheme/ccmm:iri"/>
                                    </xsl:attribute>
                                </xsl:if>
                                
                                <xsl:value-of select="$affName"/>
                            </affiliation>
                        </xsl:for-each>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <affiliation>
                            <xsl:value-of select="$affName"/>
                        </affiliation>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
        </creator>
    </xsl:template>
  
    <xsl:template match="ccmm:qualified_attribution" mode="contributor">  
      <contributor>
          <xsl:attribute name="contributorType">
              <xsl:variable name="iri" select="ccmm:role/ccmm:iri"/>
              <xsl:choose>
                  <xsl:when test="normalize-space($iri) != ''">
                      <xsl:variable name="parts" select="tokenize($iri, '/')"/>
                      <xsl:value-of select="$parts[last()]"/>
                  </xsl:when>
                  <xsl:otherwise>Other</xsl:otherwise>
              </xsl:choose>
          </xsl:attribute>
          
          <contributorName>
              <xsl:attribute name="nameType">
                  <xsl:choose>
                      <xsl:when test="ccmm:attributed_agent/ccmm:person">Personal</xsl:when>
                      <xsl:when test="ccmm:attributed_agent/ccmm:organization">Organizational</xsl:when>
                  </xsl:choose>
              </xsl:attribute>
              <xsl:choose>
                  <xsl:when test="ccmm:attributed_agent/ccmm:person">
<!--                      <xsl:value-of select="concat(ccmm:attributed_agent/ccmm:person/ccmm:family_name, ', ', ccmm:attributed_agent/ccmm:person/ccmm:given_name)"/>-->
                      <xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:name"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of select="ccmm:attributed_agent/ccmm:organization/ccmm:label"/>
                  </xsl:otherwise>
              </xsl:choose>
          </contributorName>
          
          <xsl:if test="ccmm:attributed_agent/ccmm:person/ccmm:given_name">
              <givenName><xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:given_name"/></givenName>
          </xsl:if>
          <xsl:if test="ccmm:attributed_agent/ccmm:person/ccmm:family_name">
              <familyName><xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:family_name"/></familyName>
          </xsl:if>
          
          <xsl:if test="ccmm:attributed_agent/ccmm:person/ccmm:identifier">
              <nameIdentifier nameIdentifierScheme="{ccmm:attributed_agent/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:label}" schemeURI="{ccmm:attributed_agent/ccmm:person/ccmm:identifier/ccmm:scheme/ccmm:iri}">
                  <xsl:value-of select="ccmm:attributed_agent/ccmm:person/ccmm:identifier/ccmm:iri"/>
              </nameIdentifier>                           
          </xsl:if>
          
          <xsl:for-each select="ccmm:attributed_agent/ccmm:person/ccmm:affiliation">
              <affiliation>
                  <xsl:if test="ccmm:identifier/ccmm:iri">
                      <xsl:attribute name="affiliationIdentifier">
                          <xsl:value-of select="ccmm:identifier/ccmm:iri"/>
                      </xsl:attribute>
                      
                      <xsl:attribute name="affiliationIdentifierScheme">
                          <xsl:choose>
                              <xsl:when test="ccmm:identifier/ccmm:scheme/ccmm:notation">
                                  <xsl:value-of select="ccmm:identifier/ccmm:scheme/ccmm:notation"/>
                              </xsl:when>
                              <xsl:when test="ccmm:identifier/ccmm:scheme/ccmm:label[@xml:lang='en']">
                                  <xsl:value-of select="ccmm:identifier/ccmm:scheme/ccmm:label[@xml:lang='en']"/>
                              </xsl:when>
                              <xsl:otherwise>
                                  <xsl:text>Other</xsl:text>
                              </xsl:otherwise>
                          </xsl:choose>
                      </xsl:attribute>
                      
                      <xsl:if test="ccmm:identifier/ccmm:scheme/ccmm:iri">
                          <xsl:attribute name="schemeURI">
                              <xsl:value-of select="ccmm:identifier/ccmm:scheme/ccmm:iri"/>
                          </xsl:attribute>
                      </xsl:if>
                  </xsl:if>
                  
                  <xsl:value-of select="ccmm:name"/>
              </affiliation>
          </xsl:for-each>
      </contributor>
    </xsl:template>
    
    <xsl:template match="/ccmm:dataset">
        <resource xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.7/metadata.xsd">
            
<!--            <xsl:variable name="doi" select="ccmm:identifier[ccmm:scheme/ccmm:label='DOI']/ccmm:value"/>
            <identifier identifierType="DOI">
                <xsl:value-of select="$doi"/>
            </identifier>-->
            
            <xsl:variable name="doi" select="ccmm:identifier[contains(ccmm:scheme/ccmm:iri, 'doi.org')]/ccmm:value"/>
            <xsl:if test="normalize-space($doi)">
                <identifier identifierType="DOI">
                    <xsl:value-of select="$doi"/>
                </identifier>
            </xsl:if>
            
            <alternateIdentifiers>
                <xsl:for-each select="ccmm:identifier[ccmm:scheme/ccmm:label != 'DOI']">
                    <alternateIdentifier>
                        <xsl:attribute name="alternateIdentifierType">
                            <xsl:choose>
                                <xsl:when test="ccmm:scheme/ccmm:label[@xml:lang='en']">
                                    <xsl:value-of select="ccmm:scheme/ccmm:label[@xml:lang='en']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ccmm:scheme/ccmm:label"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="ccmm:value"/>
                    </alternateIdentifier>
                </xsl:for-each>
            </alternateIdentifiers>
            
            <creators>
<!--                <xsl:apply-templates select="ccmm:qualified_attribution[ccmm:role/ccmm:label[@xml:lang='en']='Creator']" mode="creator"/>-->
                <xsl:apply-templates
                    select="ccmm:qualified_attribution[
                        tokenize(ccmm:role/ccmm:iri, '/')[last()] = 'Creator'
                    ]" mode="creator"/>    
            </creators>
            
            <!--  TODO          added also original_repository in 2.0.0 -->
            <!--<xsl:variable name="allRelations" select="
                ccmm:qualified_attribution | 
                ccmm:metadata_identification/ccmm:qualified_attribution | 
                ccmm:metadata_identification/ccmm:original_repository/ccmm:qualified_attribution
                "/>-->
            <xsl:variable name="allRelations" select="ccmm:qualified_relation | ccmm:metadata_identification/ccmm:qualified_relation"/>
            <xsl:variable name="filteredContributors" select="$allRelations[
                let $role := tokenize(ccmm:role/ccmm:iri, '/')[last()]
                return not($role = 'Creator') and not($role = 'Publisher')
                ]"/>
            
            <xsl:if test="exists($filteredContributors)">
                <contributors>
                    <xsl:apply-templates select="$filteredContributors" mode="contributor"/>
                </contributors>
            </xsl:if>
       
            <dates>
                <xsl:for-each select="ccmm:time_reference">
                    <date>
                        <xsl:attribute name="dateType">
                            <xsl:variable name="typeLabel" select="ccmm:date_type/ccmm:iri"/>
                            <xsl:variable name="tokens" select="tokenize($typeLabel, '/')"/>
                            <xsl:value-of select="$tokens[last()]"/>
                        </xsl:attribute>
                        
                        <xsl:choose>
                            <xsl:when test="ccmm:temporal_representation/ccmm:time_instant">
                                
                                <xsl:choose>
                                    <xsl:when test="ccmm:temporal_representation/ccmm:time_instant/ccmm:date_time">
                                        <xsl:value-of select="ccmm:temporal_representation/ccmm:time_instant/ccmm:date_time"/>
                                    </xsl:when>
                                    <xsl:when test="ccmm:temporal_representation/ccmm:time_instant/ccmm:date">
                                        <xsl:value-of select="ccmm:temporal_representation/ccmm:time_instant/ccmm:date"/>
                                    </xsl:when>
                                </xsl:choose>
                                
                            </xsl:when>
                            
                            <xsl:when test="ccmm:temporal_representation/ccmm:time_interval">
                                <xsl:value-of select="ccmm:temporal_representation/ccmm:time_interval/ccmm:beginning/ccmm:date"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="ccmm:temporal_representation/ccmm:time_interval/ccmm:end/ccmm:date"/>
                            </xsl:when>
                        </xsl:choose>
                    </date>
                </xsl:for-each>
                
                <!--dates from metadata_information-->
                <xsl:if test="normalize-space(ccmm:metadata_identification/ccmm:date_created)">
                    <date dateType="Created">
                        <xsl:value-of select="ccmm:metadata_identification/ccmm:date_created"/>
                    </date>
                </xsl:if>
                
                <!--dates from metadata_information-->
                <xsl:if test="normalize-space(ccmm:metadata_identification/ccmm:date_updated)">
                    <date dateType="Updated">
                        <xsl:value-of select="ccmm:metadata_identification/ccmm:date_updated"/>
                    </date>
                </xsl:if>
            </dates>
           
            <titles>
                <title>
                    <xsl:if test="ccmm:title/@xml:lang">
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="ccmm:title/@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="ccmm:title"/>
                </title>
                
                <xsl:for-each select="ccmm:alternate_title">
                    <title>
                        <xsl:if test="ccmm:title/@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="ccmm:title/@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        
                        <xsl:attribute name="titleType">
                            <xsl:variable name="relIri" select="ccmm:alternate_title_type/ccmm:iri"/>
                            <xsl:variable name="tokens" select="tokenize($relIri, '/')"/>
                            <xsl:value-of select="$tokens[last()]"/>
                        </xsl:attribute>
                        
                        <xsl:value-of select="ccmm:title"/>
                    </title>
                </xsl:for-each>
            </titles>
            
            <xsl:for-each 
                select="ccmm:qualified_attribution[tokenize(ccmm:role/ccmm:iri, '/')[last()] = 'Publisher']">
<!--            <xsl:for-each select="(ccmm:qualified_attribution[ccmm:role/ccmm:label[@xml:lang='en']='Publisher'])[1]">-->
                <publisher>
                    <xsl:variable name="org" select="ccmm:attributed_agent/ccmm:organization"/>
                    <xsl:variable name="aff" select="ccmm:attributed_agent/ccmm:person/ccmm:affiliation"/>
                    
                    <xsl:variable name="idNode" select="($aff/ccmm:identifier | $org/ccmm:identifier)[ccmm:iri][1]"/>
                    
                    <xsl:if test="$idNode/ccmm:iri">
                        <xsl:attribute name="publisherIdentifier">
                            <xsl:value-of select="$idNode/ccmm:iri"/>
                        </xsl:attribute>
                        
                        <xsl:attribute name="publisherIdentifierScheme">
                            <xsl:value-of select="($idNode/ccmm:scheme/ccmm:label[@xml:lang='en'], $idNode/ccmm:scheme/ccmm:label, 'ROR')[1]"/>
                        </xsl:attribute>
                        
                        <xsl:if test="$idNode/ccmm:scheme/ccmm:iri">
                            <xsl:attribute name="schemeURI">
                                <xsl:value-of select="$idNode/ccmm:scheme/ccmm:iri"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    
                    <xsl:choose>
                        <xsl:when test="$aff/ccmm:name">
                            <xsl:value-of select="$aff/ccmm:name"/>
                        </xsl:when>
                        <xsl:when test="$org/ccmm:name">
                            <xsl:value-of select="$org/ccmm:name"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$org/ccmm:label"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </publisher>
            </xsl:for-each>
            
            <publicationYear>
                <xsl:value-of select="ccmm:publication_year"/>
            </publicationYear>
            
            <resourceType resourceTypeGeneral="Dataset">
                <xsl:value-of select="ccmm:resource_type/ccmm:label[@xml:lang='en']"/>
            </resourceType>
            
            <!-- more subjects based on language variants-->
            <subjects>
                <xsl:for-each select="ccmm:subject">
                    <xsl:for-each select="ccmm:title">
                        <subject>
                            <xsl:if test="../ccmm:classification_code">
                                <xsl:attribute name="classificationCode">
                                    <xsl:value-of select="../ccmm:classification_code"/>
                                </xsl:attribute>
                            </xsl:if>
                            
                            <xsl:if test="../ccmm:iri">
                                <xsl:attribute name="valueURI">
                                    <xsl:value-of select="../ccmm:iri"/>
                                </xsl:attribute>
                            </xsl:if>
                            
                            <xsl:if test="../ccmm:subject_scheme">
                                <xsl:attribute name="subjectScheme">
                                    <xsl:value-of select="(../ccmm:subject_scheme/ccmm:label[@xml:lang='en'], ../ccmm:subject_scheme/ccmm:label)[1]"/>
                                </xsl:attribute>
                                <xsl:if test="../ccmm:subject_scheme/ccmm:iri">
                                    <xsl:attribute name="schemeURI">
                                        <xsl:value-of select="../ccmm:subject_scheme/ccmm:iri"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:if>
                            
                            <xsl:if test="@xml:lang">
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="@xml:lang"/>
                                </xsl:attribute>
                            </xsl:if>
                            
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>
                </xsl:for-each>
                
                <xsl:for-each select="ccmm:keyword">
                    <subject>
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </subject>
                </xsl:for-each>
            </subjects>
            
<!--            NOTE description is also used for describing metadata (distribution, location type) not suitable for datacite schema-->
            <descriptions>
                <xsl:for-each select="ccmm:description">
                    <xsl:variable name="parsedType" select="tokenize(ccmm:description_type/ccmm:iri, '/')[last()]" />
                    <xsl:variable name="finalType" select="if (normalize-space($parsedType)) then $parsedType else 'Other'" />
                    
                    <description descriptionType="{$finalType}">
                        <xsl:if test="ccmm:description_text/@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="ccmm:description_text/@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="ccmm:description_text"/>
                    </description>
                </xsl:for-each>
                
                <xsl:for-each select="ccmm:distribution/ccmm:distribution_downloadable_file">
                    <description descriptionType="TechnicalInfo" xml:lang="cs">
                        <xsl:value-of select="concat('DistTitle: ', (ccmm:title)[1])"/>
                        <xsl:text> | </xsl:text>
                        <xsl:value-of select="concat('FormatIRI: ', (ccmm:format/ccmm:iri)[1])"/>
                        <xsl:if test="ccmm:licence/ccmm:iri">
                            <xsl:text> | </xsl:text>
                            <xsl:value-of select="concat('LicenceIRI: ', ccmm:licence/ccmm:iri)"/>
                        </xsl:if>
                    </description>
                </xsl:for-each>
                
                <xsl:for-each select="ccmm:distribution/ccmm:distribution_data_service">
                    <description descriptionType="TechnicalInfo" xml:lang="cs">
                        <xsl:value-of select="concat('ServiceTitle: ', (ccmm:title)[1])"/>
                        <xsl:if test="@access_url or ccmm:access_service/ccmm:endpoint_url/ccmm:resource_url">
                            <xsl:text> | </xsl:text>
                            <xsl:value-of select="concat('ServiceURL: ', (@access_url, ccmm:access_service/ccmm:endpoint_url/ccmm:resource_url)[1])"/>
                        </xsl:if>
                        <xsl:if test="ccmm:licence/ccmm:iri">
                            <xsl:text> | </xsl:text>
                            <xsl:value-of select="concat('LicenceIRI: ', ccmm:licence/ccmm:iri)"/>
                        </xsl:if>
                    </description>
                </xsl:for-each>
                
                <xsl:for-each select="ccmm:location[ccmm:relation_type/ccmm:iri]">
                    <description descriptionType="TechnicalInfo" xml:lang="cs">
                        <xsl:value-of select="concat('LocName: ', ccmm:label)"/>
                        <xsl:text> | </xsl:text>
                        <xsl:variable name="typeToken" select="tokenize(ccmm:relation_type/ccmm:iri, '/')[last()]"/>
                        <xsl:value-of select="concat('LocType: ', $typeToken)"/>
                    </description>
                </xsl:for-each>
            </descriptions>
            
            <formats>
                <xsl:for-each select="distinct-values(ccmm:distribution/ccmm:distribution_downloadable_file/ccmm:format/ccmm:label)">
                    <format>
                        <xsl:value-of select="."/>
                    </format>
                </xsl:for-each>
            </formats>
            <fundingReferences>
                <xsl:for-each select="ccmm:funding_reference">
                    <fundingReference>
                        <funderName>
                            <xsl:value-of select="ccmm:funder/ccmm:organization/ccmm:name"/>
                        </funderName>
                        
                        <xsl:variable name="funderId" select="ccmm:funder/ccmm:organization/ccmm:identifier[1]"/>
                        <xsl:if test="normalize-space($funderId/ccmm:value)">
                            <funderIdentifier>
                                <xsl:attribute name="funderIdentifierType">
                                    <xsl:choose>
                                        <xsl:when test="normalize-space($funderId/ccmm:scheme/ccmm:notation)">
                                            <xsl:value-of select="$funderId/ccmm:scheme/ccmm:notation"/>
                                        </xsl:when>
                                        <xsl:when test="normalize-space($funderId/ccmm:scheme/ccmm:label)">
                                            <xsl:value-of select="$funderId/ccmm:scheme/ccmm:label"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>Other</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="$funderId/ccmm:value"/>
                            </funderIdentifier>
                        </xsl:if>          
                        
                        <xsl:if test="ccmm:local_identifier">
                            <awardNumber>
                                <xsl:value-of select="ccmm:local_identifier"/>
                            </awardNumber>
                        </xsl:if>
                        
                        <xsl:if test="ccmm:award_title">
                            <awardTitle>
                                <xsl:value-of select="ccmm:award_title"/>
                            </awardTitle>
                        </xsl:if>
                    </fundingReference>
                </xsl:for-each>
            </fundingReferences>
            
            <version>
                <xsl:value-of select="ccmm:version"/>
            </version>

<!-- for version 1.1.0 -->
<!--            <rightsList>
                <xsl:for-each select="ccmm:terms_of_use/ccmm:license">
                    <rights>
                        <xsl:if test="ccmm:iri">
                            <xsl:attribute name="rightsURI">
                                <xsl:value-of select="ccmm:iri"/>
                            </xsl:attribute>
                        </xsl:if>   
                        
                        <xsl:if test="ccmm:label[@xml:lang='en'] or ccmm:label">
                            <xsl:variable name="rawLabel" select="(ccmm:label[@xml:lang='en'], ccmm:label)[1]" />
                            <xsl:variable name="fullLabel" select="normalize-space(replace($rawLabel, ' License$', ''))" />
                            
                            <xsl:variable name="mappedId" select="$licenseMap//*:entry[@name = $fullLabel]/@id" />
                            
                            <xsl:attribute name="rightsIdentifier">
                                <xsl:choose>
                                    <xsl:when test="$mappedId">
                                        <xsl:value-of select="$mappedId"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$fullLabel"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        
                        <!-\-<xsl:if test="ccmm:label[@xml:lang='en'] or ccmm:label">
                            <xsl:attribute name="rightsIdentifier">
                                <xsl:value-of select="(ccmm:label[@xml:lang='en'], ccmm:label)[1]"/>
                            </xsl:attribute>
                        </xsl:if>-\->
                        
                        <xsl:attribute name="rightsIdentifierScheme">SPDX</xsl:attribute>
                        
                        <xsl:attribute name="schemeURI">https://spdx.org/licenses/</xsl:attribute>
                        
                        <xsl:if test="ccmm:label/@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="ccmm:label[1]/@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        
                        <xsl:value-of select="(ccmm:label[@xml:lang='en'], ccmm:label)[1]"/>
                    </rights>
                </xsl:for-each>
                
                <xsl:for-each select="ccmm:terms_of_use/ccmm:access_rights">
                    <rights>
                        <xsl:if test="ccmm:iri">
                            <xsl:attribute name="rightsURI" select="ccmm:iri"/>
                        </xsl:if>
                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                        <xsl:value-of select="ccmm:label[@xml:lang='en']"/>
                    </rights>
                </xsl:for-each>
                
            </rightsList>-->
            
            <rightsList>
                <xsl:for-each select="ccmm:access_rights">
                    <rights>
                        <xsl:if test="ccmm:iri">
                            <xsl:attribute name="rightsURI" select="ccmm:iri"/>
                        </xsl:if>
                        <xsl:if test="ccmm:label[@xml:lang='en']">
                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                            <xsl:value-of select="ccmm:label[@xml:lang='en']"/>
                        </xsl:if>
                    </rights>
                </xsl:for-each>
                
                <!-- log all licenses from distributions too (only unique ones) -->
                <xsl:for-each-group 
                    select="ccmm:distribution//ccmm:licence" 
                    group-by="(ccmm:iri, ccmm:title[@xml:lang='en'], ccmm:title)[1]">
                    
                    <rights>
                        <xsl:if test="ccmm:iri">
                            <xsl:attribute name="rightsURI" select="ccmm:iri"/>
                        </xsl:if>
                        
                        <xsl:variable name="rawLabel" select="(ccmm:title[@xml:lang='en'], ccmm:title)[1]" />
                        
                        <xsl:if test="$rawLabel">
                            <xsl:variable name="fullLabel" select="normalize-space(replace($rawLabel, ' License$', ''))" />
                            <xsl:variable name="mappedId" select="$licenseMap//*:entry[@name = $fullLabel]/@id" />
                            
                            <xsl:attribute name="rightsIdentifier">
                                <xsl:choose>
                                    <xsl:when test="$mappedId">
                                        <xsl:value-of select="$mappedId"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$fullLabel"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            
                            <xsl:attribute name="rightsIdentifierScheme">SPDX</xsl:attribute>
                            <xsl:attribute name="schemeURI">https://spdx.org/licenses/</xsl:attribute>
                        </xsl:if>
                        
                        <xsl:if test="ccmm:title/@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="ccmm:title[1]/@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        
                        <xsl:value-of select="(ccmm:title[@xml:lang='en'], ccmm:title)[1]"/>
                    </rights>
                </xsl:for-each-group>
            </rightsList>
            
            <xsl:if test="normalize-space(ccmm:primary_language/ccmm:iri)">
                <language>
                    <xsl:variable name="languageIri" select="ccmm:primary_language/ccmm:iri"/>
                    <xsl:variable name="tokens" select="tokenize($languageIri, '/')"/>
                    <xsl:value-of select="$tokens[last()]"/>
                </language>
            </xsl:if>
            
            <relatedIdentifiers>
                <!-- original repository -->
      <!--          <xsl:if test="ccmm:metadata_identification/ccmm:original_repository/ccmm:iri">
                    <relatedIdentifier relatedIdentifierType="URL" relationType="IsVariantFormOf" resourceTypeGeneral="Other">
                        <xsl:value-of select="ccmm:metadata_identification/ccmm:original_repository/ccmm:iri"/>
                    </relatedIdentifier>
                </xsl:if>-->
                
                <!-- distribution downloadable_file -->
                <xsl:for-each select="ccmm:distribution/ccmm:distribution_downloadable_file">
                    <xsl:if test="ccmm:download_url/ccmm:iri">
                        <relatedIdentifier relatedIdentifierType="URL" relationType="HasPart" resourceTypeGeneral="Other">
                            <xsl:value-of select="ccmm:download_url/ccmm:iri"/>
                        </relatedIdentifier>
                    </xsl:if>
                    
                    <xsl:if test="ccmm:access_url">
                        <relatedIdentifier relatedIdentifierType="URL" relationType="IsDocumentedBy">
                            <xsl:value-of select="ccmm:access_url"/>
                        </relatedIdentifier>
                    </xsl:if>
                </xsl:for-each>
                
                <!-- distribution data_service -->
                <xsl:for-each select="ccmm:distribution/ccmm:distribution_data_service">
                    <xsl:variable name="serviceUrl" select="(@access_url, ccmm:access_service/ccmm:endpoint_url/ccmm:resource_url, ccmm:access_service/ccmm:iri)[1]" />
                    
                    <xsl:if test="normalize-space($serviceUrl)">
                        <relatedIdentifier relatedIdentifierType="URL" relationType="HasPart" resourceTypeGeneral="Service">
                            <xsl:value-of select="$serviceUrl"/>
                        </relatedIdentifier>
                    </xsl:if>
                    
                    <xsl:if test="ccmm:documentation/ccmm:iri">
                        <relatedIdentifier relatedIdentifierType="URL" relationType="IsDocumentedBy">
                            <xsl:value-of select="ccmm:documentation/ccmm:iri"/>
                        </relatedIdentifier>
                    </xsl:if>
                </xsl:for-each>
            </relatedIdentifiers>

            
            <xsl:variable name="firstByteSize" select="(ccmm:distribution/ccmm:distribution_downloadable_file/ccmm:byte_size[normalize-space(.)])[1]"/>
            
            <xsl:if test="$firstByteSize">
                <sizes>
                    <size>
                        <xsl:variable name="bytes" select="number($firstByteSize)"/>
                        <xsl:choose>
                            <xsl:when test="$bytes &gt; 1048576">
                                <xsl:value-of select="format-number($bytes div 1048576, '0.00')"/>
                                <xsl:text> MB</xsl:text>
                            </xsl:when>
                            <xsl:when test="$bytes &gt; 1024">
                                <xsl:value-of select="format-number($bytes div 1024, '0.0')"/>
                                <xsl:text> KB</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$bytes"/>
                                <xsl:text> B</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </size>
                </sizes>
            </xsl:if>
            
            <relatedItems>
                <!-- Processing original repository information for backward compatibility -->
                <xsl:for-each select="ccmm:metadata_identification/ccmm:original_repository">
                    <relatedItem relatedItemType="Other" relationType="IsVariantFormOf">
                        <xsl:if test="ccmm:iri">
                            <relatedItemIdentifier relatedItemIdentifierType="URL">
                                <xsl:value-of select="ccmm:iri"/>
                            </relatedItemIdentifier>
                        </xsl:if>
                        
                        <titles>
                            <title>
                                <xsl:if test="ccmm:label/@xml:lang">
                                    <xsl:attribute name="xml:lang">
                                        <xsl:value-of select="ccmm:label/@xml:lang"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="ccmm:label"/>
                            </title>
                            <!-- for backward compatibility to CCMM -->
                            <title titleType="Other">CCMM:OriginalRepository</title>
                        </titles>
                        
                        <xsl:variable name="repoPub" select="ccmm:qualified_attribution[tokenize(ccmm:role/ccmm:iri, '/')[last()] = 'Publisher']/ccmm:attributed_agent"/>
                        <xsl:if test="$repoPub">
                            <publisher>
                                <xsl:choose>
                                    <xsl:when test="$repoPub/ccmm:organization/ccmm:name">
                                        <xsl:value-of select="$repoPub/ccmm:organization/ccmm:name"/>
                                    </xsl:when>
                                    <xsl:when test="$repoPub/ccmm:organization/ccmm:label">
                                        <xsl:value-of select="$repoPub/ccmm:organization/ccmm:label"/>
                                    </xsl:when>
                                    <xsl:when test="$repoPub/ccmm:person/ccmm:name">
                                        <xsl:value-of select="$repoPub/ccmm:person/ccmm:name"/>
                                    </xsl:when>
                                </xsl:choose>
                            </publisher>
                        </xsl:if>
                    </relatedItem>
                </xsl:for-each>
                
                <xsl:for-each select="ccmm:related_resource">
                    <relatedItem>
                        <xsl:if test="ccmm:resource_relation_type/ccmm:iri">
                            <xsl:attribute name="relationType">
                                <xsl:variable name="relIri" select="ccmm:resource_relation_type/ccmm:iri"/>
                                <xsl:variable name="tokens" select="tokenize($relIri, '/')"/>
                                <xsl:value-of select="$tokens[last()]"/>
                            </xsl:attribute>
                        </xsl:if>
                        
                        <xsl:attribute name="relatedItemType">
                            <xsl:variable name="typeMapping" select="document('https://raw.githubusercontent.com/techlib/CCMM-DataCite-mappings/refs/heads/dev/exhaustive-mapping/mappings/resource_mapping_gemini_coar_datacite.xml')/mappings"/>
                            <xsl:choose>
                                <!--<xsl:when test="ccmm:resource_type/ccmm:label">
                                    <xsl:value-of select="(ccmm:resource_type/ccmm:label[@xml:lang='en'], ccmm:resource_type/ccmm:label)[1]"/>
                                </xsl:when>-->
                                
                                <xsl:when test="ccmm:resource_type/ccmm:iri and normalize-space(ccmm:resource_type/ccmm:iri) != ''">
                                    <xsl:variable name="currentIri" select="normalize-space(ccmm:resource_type/ccmm:iri)"/>
                                    <xsl:variable name="mappedValue" select="$typeMapping/map[@coar_iri = $currentIri]/@dc_type"/>
                                    
                                    <xsl:choose>
                                        <xsl:when test="$mappedValue">
                                            <xsl:value-of select="$mappedValue"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>Other</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Other</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        
                        <!--<xsl:if test="ccmm:identifier/ccmm:value">
                            <relatedItemIdentifier>
                                <xsl:attribute name="relatedItemIdentifierType">
                                    <xsl:value-of select="(ccmm:identifier/ccmm:scheme/ccmm:label[@xml:lang='en'], ccmm:identifier/ccmm:scheme/ccmm:label)[1]"/>
                                </xsl:attribute>
                                <xsl:value-of select="ccmm:identifier/ccmm:value"/>
                            </relatedItemIdentifier>
                        </xsl:if>-->
                        
                        <!--<xsl:if test="ccmm:resource_url">
                            <relatedItemIdentifier>
                                <xsl:value-of select="ccmm:resource_url"/>
                            </relatedItemIdentifier>
                        </xsl:if>-->
                        
                        <xsl:variable name="dateValue">
                            <xsl:choose>
                                <xsl:when test="ccmm:time_reference/ccmm:temporal_representation/ccmm:time_interval/ccmm:beginning/ccmm:date_time">
                                    <xsl:value-of select="ccmm:time_reference/ccmm:temporal_representation/ccmm:time_interval/ccmm:beginning/ccmm:date_time"/>
                                </xsl:when>
                                <xsl:when test="ccmm:time_reference/ccmm:temporal_representation/ccmm:time_instant/ccmm:date">
                                    <xsl:value-of select="ccmm:time_reference/ccmm:temporal_representation/ccmm:time_instant/ccmm:date"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:if test="normalize-space($dateValue) != ''">
                            <publicationYear>
                                <xsl:value-of select="substring(normalize-space($dateValue), 1, 4)"/>
                            </publicationYear>
                        </xsl:if>
                        
                        <xsl:variable name="pub" select="ccmm:qualified_attribution[ccmm:role/ccmm:label[@xml:lang='en'] = 'Publisher']/ccmm:role/ccmm:label[@xml:lang='en']"/>
                        
                        <xsl:if test="normalize-space($pub) != ''">
                            <publisher>
                                <xsl:value-of select="$pub"/>
                            </publisher>
                        </xsl:if>
                        
                        <xsl:variable name="relCreators" select="ccmm:qualified_attribution[tokenize(ccmm:role/ccmm:iri, '/')[last()] = 'Creator']"/>
                        
                        <xsl:if test="$relCreators">
                            <creators>
                                <xsl:apply-templates select="$relCreators" mode="creator"/>
                            </creators>
                        </xsl:if>
                        
                        <titles>
                            <title>
                                <xsl:value-of select="(ccmm:title[@xml:lang='en'], ccmm:title)[1]"/>
                            </title>
                            <xsl:for-each select="ccmm:alternate_title">
                                <title>
                                    <xsl:attribute name="titleType">
                                        <xsl:variable name="relIri" select="ccmm:alternate_title_type/ccmm:iri"/>
                                        <xsl:variable name="tokens" select="tokenize($relIri, '/')"/>
                                        <xsl:value-of select="$tokens[last()]"/>
                                    </xsl:attribute>
                                </title>
                            </xsl:for-each>
                        </titles>
                        
                        <xsl:variable name="relContributors" select="ccmm:qualified_attribution[tokenize(ccmm:role/ccmm:iri, '/')[last()] != 'Creator']"/>
                        
                        <xsl:if test="$relContributors">
                            <contributors>
                                <xsl:apply-templates select="$relContributors" mode="contributor"/>
                            </contributors>
                        </xsl:if>
                        
                    </relatedItem>
                </xsl:for-each>
            </relatedItems>
            
            <xsl:if test="ccmm:location">
            
                <geoLocations>
                    <xsl:for-each select="ccmm:location">
                        <geoLocation>
                            <xsl:if test="ccmm:name">
                                <geoLocationPlace>
                                    <xsl:value-of select="ccmm:name"/>
                                </geoLocationPlace>
                            </xsl:if>
                            
                            <xsl:if test="ccmm:bounding_box">
                                <geoLocationBox>
                                    <xsl:variable name="lower" select="tokenize(normalize-space(ccmm:bounding_box/ccmm:gml/gml:Envelope/gml:lowerCorner), ' ')"/>
                                    <xsl:variable name="upper" select="tokenize(normalize-space(ccmm:bounding_box/ccmm:gml/gml:Envelope/gml:upperCorner), ' ')"/>
                                    
                                    <westBoundLongitude><xsl:value-of select="$lower[2]"/></westBoundLongitude>
                                    <southBoundLatitude><xsl:value-of select="$lower[1]"/></southBoundLatitude>
                                    <eastBoundLongitude><xsl:value-of select="$upper[2]"/></eastBoundLongitude>
                                    <northBoundLatitude><xsl:value-of select="$upper[1]"/></northBoundLatitude>
                                </geoLocationBox>
                            </xsl:if>
                            
                            <xsl:if test="ccmm:geometry/gml:lowerCorner and not(ccmm:bounding_box)">
                                <geoLocationPoint>
                                    <xsl:variable name="point" select="tokenize(normalize-space(ccmm:geometry/gml:lowerCorner), ' ')"/>
                                    <pointLongitude><xsl:value-of select="$point[1]"/></pointLongitude>
                                    <pointLatitude><xsl:value-of select="$point[2]"/></pointLatitude>
                                </geoLocationPoint>
                            </xsl:if>
                            
                            <xsl:if test="ccmm:geometry/ccmm:wkt[contains(., 'POLYGON')]">
                                <geoLocationPolygon>
                                    <xsl:variable name="wktContent" select="ccmm:geometry/ccmm:wkt"/>
                                    
                                    <xsl:variable name="cleanWkt" select="replace(replace($wktContent, 'POLYGON\s*\(\(', ''), '\)\)', '')"/>
                                    
                                    <xsl:variable name="points" select="tokenize($cleanWkt, ',')"/>
                                    
                                    <xsl:for-each select="$points">
                                        <xsl:variable name="coords" select="tokenize(normalize-space(.), '\s+')"/>
                                        <xsl:if test="count($coords) >= 2">
                                            <polygonPoint>
                                                <pointLongitude>
                                                    <xsl:value-of select="normalize-space($coords[1])"/>
                                                </pointLongitude>
                                                <pointLatitude>
                                                    <xsl:value-of select="normalize-space($coords[2])"/>
                                                </pointLatitude>
                                            </polygonPoint>
                                        </xsl:if>
                                    </xsl:for-each>
                                </geoLocationPolygon>
                            </xsl:if>
                            
                        </geoLocation>
                    </xsl:for-each>
                </geoLocations>
            </xsl:if>
            
        </resource>
    </xsl:template>
    
</xsl:stylesheet>