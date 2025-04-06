# Serbian Electoral System - Event Storming Model

## Bounded Context: Candidate Registration and Electoral Lists

### Role: Political Party

**Command:** SubmitElectoralListApplication

- **Aggregate:** ElectoralListApplication
- **Event:** ElectoralListApplicationSubmitted
- **Policy:** ValidateListRequirements
  - Checks complete documentation (list of candidates, statements of acceptance)
  - Verifies party has opened a special campaign account (Art. 24, Law on Financing Political Activities)
  - Checks certified voter support signatures
  - Source: <https://www.paragraf.rs/propisi/zakon_o_izboru_narodnih_poslanika.html>

**Command:** CollectVoterSupportSignatures  

- **Aggregate:** VoterSupportCollection
- **Event:** SignaturesCollected
- **Policy:** CheckSignatureRequirements
  - Parliamentary elections: 10,000 signatures required (5,000 for national minority lists)
  - Local elections: 200 signatures for municipalities under 20,000 voters
  - Source: <https://www.rik.parlament.gov.rs/tekst/sr/2236/propisi.php>

### Role: Electoral Commission (RIK/OIK)

**Command:** ReviewElectoralList

- **Aggregate:** ElectoralListApplication
- **Event:** ElectoralListApproved or ElectoralListRejected
- **Policy:** VerifyDocumentationCompleteness
  - Checks gender quota compliance (40% female candidates)
  - Confirms all supporting documents are valid
  - Source: RIK Guidelines 2022 elections

**Command:** RequestListCorrection

- **Aggregate:** ElectoralListApplication
- **Event:** CorrectionRequested
- **Policy:** SetCorrectionDeadline
  - Submitter given 48 hours to correct deficiencies
  - Source: Art. 42, Law on Election of MPs

### Role: Voter

**Command:** SignSupportForList

- **Aggregate:** VoterSupportSignature
- **Event:** VoterSupportSigned
- **Policy:** EnforceOneListSupportRule
  - Voter can only support one list with valid signature
  - Signature must be certified by notary public or municipal administration
  - Source: <https://www.paragraf.rs/propisi/zakon-o-lokalnim-izborima.html>

## Bounded Context: Voter Registration and Management

### Role: Ministry of Public Administration

**Command:** MaintainUnifiedVoterRegistry

- **Aggregate:** UnifiedVoterRegistry
- **Event:** VoterRegistryUpdated
- **Policy:** ApplyAutomaticUpdates
  - Registry includes all citizens who turn 18 by election day
  - Source: Law on Unified Voter Registry, Art. 4-6

### Role: Voter

**Command:** RequestRegistryCorrection

- **Aggregate:** VoterRegistryEntry
- **Event:** CorrectionRequestSubmitted
- **Policy:** ProcessCorrectionRequest
  - Must be submitted no later than 72 hours before election day
  - After registry closing, only by court decision
  - Source: <https://www.paragraf.rs/propisi/zakon_o_jedinstvenom_birackom_spisku.html>

### Role: Local Administration

**Command:** UpdateLocalVoterRegistry

- **Aggregate:** LocalVoterRegistryPartition
- **Event:** LocalRegistryUpdated
- **Policy:** SynchronizeWithCentralRegistry
  - Local changes must be reflected in central database within 24 hours
  - Source: <https://mduls.gov.rs/registri/jedinstveni-biracki-spisak/>

## Bounded Context: Polling Station Operations

### Role: Electoral Commission

**Command:** FormPollingStationCommittees

- **Aggregate:** PollingStationCommittee
- **Event:** CommitteeFormed
- **Policy:** EnsureMultipartyRepresentation
  - Standing members + extended members from all electoral lists
  - Parliamentary parties given priority in standing membership
  - Source: Art. 34-36, Law on Election of MPs

**Command:** DistributeElectoralMaterials

- **Aggregate:** ElectoralMaterialsPackage
- **Event:** MaterialsDistributed
- **Policy:** EnsureCompleteMaterials
  - Each station receives exact number of ballots matching registry +0.5%
  - Includes ballot boxes, voting booths, UV lamps, spray
  - Source: RIK Guidelines for 2022 elections

### Role: Polling Station Committee President

**Command:** OpenPollingStation

- **Aggregate:** PollingStation
- **Event:** PollingStationOpened
- **Policy:** VerifyEmptyBallotBox
  - Control sheet inserted as first item in empty ballot box
  - Minimum 3 committee members must be present
  - Source: Art. 91-92, Law on Election of MPs

**Command:** ClosePollingStation

- **Aggregate:** PollingStation
- **Event:** PollingStationClosed
- **Policy:** AllowRemainingQueued
  - Voters in queue at 8PM allowed to vote
  - Source: Electoral Commission Instructions, 2022

### Role: Polling Station Committee

**Command:** ProcessVoter

- **Aggregate:** VotingProcess
- **Event:** VoterProcessed
- **Policy:** VerifyVoterIdentity
  - Check ID document and voter registry
  - Apply invisible spray on voter's finger
  - Verify with UV lamp to prevent double voting
  - Source: Art. 76-78, Law on Election of MPs

**Command:** CountVotes

- **Aggregate:** VoteCount
- **Event:** VotesCounted
- **Policy:** RecordAllParameters
  - Count unused ballots first, then count votes by list
  - Record total turnout, valid and invalid ballots
  - All members must sign protocol
  - Source: Art. 101-105, Law on Election of MPs

## Bounded Context: Results Processing and Mandate Allocation

### Role: Local Electoral Commission

**Command:** CollectLocalResults

- **Aggregate:** LocalResultsCollection
- **Event:** LocalResultsCollected
- **Policy:** VerifyPollingStationProtocols
  - Check all protocols are signed and complete
  - Compare number of ballots with signatures in registry
  - Source: Art. 106, Law on Election of MPs

### Role: Republican Electoral Commission (RIK)

**Command:** DetermineElectionResults

- **Aggregate:** ElectionResults
- **Event:** PreliminaryResultsAnnounced
- **Policy:** ApplyLegalThreshold
  - 3% threshold for regular lists
  - No threshold for national minority lists
  - Apply 35% bonus to minority list votes if under 3%
  - Source: <https://www.rik.parlament.gov.rs/vest/sr/2526/izmene-izbornih-zakona-u-skupstini-srbije.php>

**Command:** AllocateMandates

- **Aggregate:** MandateAllocation
- **Event:** MandatesAllocated
- **Policy:** ApplyDHondtMethod
  - Divide votes by successive divisors (1, 2, 3...)
  - Allocate seats to highest quotients
  - Mandates assigned in order on electoral list
  - Source: Art. 127-128, Law on Election of MPs

**Command:** HandleComplaints

- **Aggregate:** ElectionComplaint
- **Event:** ComplaintProcessed
- **Policy:** ApplyExpeditiousResolution
  - 48 hours for RIK to decide on complaints
  - Further appeal to Administrative Court within 72 hours
  - Source: Art. 151-153, Law on Election of MPs

### Role: Administrative Court

**Command:** RuleOnAppeal

- **Aggregate:** ElectionAppeal
- **Event:** AppealRuled
- **Policy:** EnforceBriskAdjudication
  - Court must decide within 72 hours of receiving appeal
  - Decision is final within electoral system
  - Source: <https://www.up.sud.rs/latinica/izborni-predmeti>

## Bounded Context: Campaign Regulation

### Role: Anti-Corruption Agency

**Command:** MonitorCampaignFinancing

- **Aggregate:** CampaignFinancingReport
- **Event:** IrregularityDetected
- **Policy:** EnforceFinancialLimits
  - Maximum donation amounts (individual/corporate)
  - Required special account for campaign funds
  - Source: Art. 20-22, Law on Financing of Political Activities

**Command:** ReviewFinancialReports

- **Aggregate:** PostElectionFinancialReport
- **Event:** ReportAnalyzed
- **Policy:** ApplyMandatoryReporting
  - Political entities must submit reports 30 days after elections
  - Reports published on Agency website
  - Source: <https://www.acas.rs/izvestaji-o-finansiranju-kampanje>

### Role: Regulatory Authority for Electronic Media (REM)

**Command:** MonitorMediaCoverage

- **Aggregate:** MediaMonitoringReport
- **Event:** MediaViolationIdentified
- **Policy:** EnforceEqualRepresentation
  - Equal time for all electoral lists on public media
  - Commercial media must apply fair pricing to all participants
  - Source: <https://www.rem.rs/uploads/files/izborni%20proces/Pravilnik%20o%20nacinu%20izvrsavanja%20obaveza.pdf>

## Bounded Context: Local Community Elections

### Role: Municipality

**Command:** OrganizeLocalCommunityElections

- **Aggregate:** LocalCommunityElection
- **Event:** LocalElectionsScheduled
- **Policy:** ApplyMunicipalRegulations
  - Based on municipal statute for each local community
  - Direct secret ballot required by law
  - Source: Art. 74, Law on Local Self-Government

### Role: Local Community Candidate

**Command:** SubmitLocalCandidacy

- **Aggregate:** LocalCommunityCandidacy
- **Event:** LocalCandidacySubmitted
- **Policy:** ValidateLocalRequirements
  - Typically requires 10-20 supporting signatures from neighborhood
  - Must have residence in that local community
  - Source: Municipal decisions on local community operations

## Bounded Context: Housing Community Elections

### Role: Housing Community Assembly

**Command:** NominateHousingManager

- **Aggregate:** HousingManagerNomination
- **Event:** ManagerNominated
- **Policy:** ValidateOwnershipStatus
  - Only apartment owners can be nominated
  - Manager elected for 4-year term
  - Source: Art. 49, Law on Housing and Building Maintenance

**Command:** ElectHousingManager

- **Aggregate:** HousingManagerElection
- **Event:** ManagerElected
- **Policy:** RequireQuorum
  - Majority of present owners must vote (often 50%+1)
  - Simple majority for selection among candidates
  - Source: <https://www.mgsi.gov.rs/cir/dokumenti/zakon-o-stanovanju-i-odrzavanju-zgrada>

### Role: Local Government

**Command:** AppointProfessionalManager

- **Aggregate:** ProfessionalManagerAppointment
- **Event:** ProfessionalManagerAppointed
- **Policy:** EnforceHousingLaw
  - Appointed if community fails to elect manager within 60 days
  - Mandatory registration in Registry of Housing Communities
  - Source: Art. 54, Law on Housing and Building Maintenance

## Domain Events and State Transitions

### Electoral List Lifecycle

1. **ElectoralListPreparationStarted**
   - Collecting candidate consent forms
   - Preparing documentation

2. **VoterSupportCollectionInitiated**
   - Collecting certified signatures from voters
   - State: InPreparation

3. **ElectoralListApplicationSubmitted**
   - Complete package submitted to electoral commission
   - State: UnderReview

4. **ListCorrectionRequested** (conditional)
   - Minor deficiencies identified
   - State: AwaitingCorrection

5. **ElectoralListApproved** / **ElectoralListRejected**
   - Commission decides on compliance
   - State: Approved (assigned list number) / Rejected

6. **CandidacyWithdrawn** (optional)
   - Submitter decides to withdraw from race
   - State: Withdrawn

7. **ElectoralListParticipatesInElection**
   - Final state: ActiveInElection

### Polling Station Operation States

1. **PollingStationCommitteeAppointed**
   - Members appointed at least 10 days before election
   - State: Formed

2. **ElectoralMaterialsReceived**
   - Committee president receives materials day before
   - State: Prepared

3. **PollingStationOpened**
   - 7AM on election day, after verification procedures
   - State: Active

4. **VotingInProgress**
   - Regular processing of voters throughout day
   - State: Receiving Voters

5. **PollingStationClosed**
   - 8PM, or after last queued voter
   - State: Closed

6. **VotesCounted**
   - Ballot counting procedure completed
   - State: ResultsEstablished

7. **ProtocolSubmitted**
   - Materials and protocol delivered to higher commission
   - State: Completed

### Vote Counting Workflow

1. **CountingStarted**
   - Verify ballot box seal is intact
   - Extract control sheet first
   - State: PreparingForCount

2. **UnusedBallotsProcessed**
   - Count and pack unused ballots
   - State: CountingUnusedMaterial

3. **VoterSignaturesCounted**
   - Count signatures in voter registry excerpt
   - State: VerifyingParticipation

4. **BallotsExtracted**
   - Empty ballot box and count total ballots
   - State: VerifyingBallotCount

5. **ValidAndInvalidSeparated**
   - Sort ballots by validity
   - State: ClassifyingBallots

6. **VotesForListsCounted**
   - Count votes for each electoral list
   - State: CountingByList

7. **ProtocolPrepared**
   - Fill in all required data in official protocol
   - State: DocumentingResults

8. **ProtocolSigned**
   - All members sign protocol (or note objections)
   - State: ResultsFinalized

## Business Invariants With Real Sources

### Electoral List Formation

1. **GenderQuotaInvariant**
   - At least 40% candidates must be of less represented gender
   - At least 2 in each group of 5 candidates must be of less represented gender
   - Source: Art. 42, Law on Election of MPs (2022 amendments)
   - Reference: <https://www.rodnaravnopravnost.gov.rs/sr/vesti/rodna-kvota-na-izbornim-listama-povecana-na-40-odsto>

2. **SupportSignaturesInvariant**
   - Parliamentary: 10,000 valid signatures (reduced to 5,000 for minority lists)
   - Local: Varies by municipality size (200-3,000)
   - Source: Art. 41, Law on Election of MPs
   - Reference: <https://www.paragraf.rs/propisi/zakon_o_izboru_narodnih_poslanika.html>

3. **OneVoterOneSupportInvariant**
   - Voter can support only one list with valid signature
   - First valid signature counts if multiple are found
   - Source: Art. 43, Law on Local Elections
   - Reference: <https://www.paragraf.rs/propisi/zakon-o-lokalnim-izborima.html>

### Vote Counting

1. **BallotValidityInvariant**
   - Ballot must have electoral commission stamp and polling station stamp
   - Voter intent must be clear (one list circled)
   - Source: Art. 85-87, Law on Election of MPs
   - Reference: RIK Guidelines for 2022 elections

2. **CountingTransparencyInvariant**
   - All committee members must be present during counting
   - Representatives of all lists must be allowed to observe
   - Source: Art. 95-98, Law on Election of MPs
   - Reference: OSCE Election Observation Mission Report, 2022

### Mandate Allocation

1. **ThresholdInvariant**
   - 3% threshold for regular lists (lowered from 5% in 2020)
   - No threshold for national minority lists
   - Source: Art. 81-82, Law on Election of MPs
   - Reference: <https://www.rik.parlament.gov.rs/vest/sr/2526/>

2. **DHondtMethodInvariant**
   - Seats allocated by highest quotient method
   - Lists get seats in proportion to votes received
   - Source: Art. 127-128, Law on Election of MPs
   - Reference: <https://www.stat.gov.rs/sr-latn/oblasti/izbori/parlamentarni-izbori/>

3. **ListOrderMandateAssignmentInvariant**
   - Mandates assigned strictly in order from list
   - No party discretion to change order (post-2011 reform)
   - Source: Art. 133, Law on Election of MPs
   - Reference: <https://www.paragraf.rs/propisi/zakon_o_izboru_narodnih_poslanika.html>

### Campaign Regulation

1. **CampaignFinancingInvariant**
   - Special account required for all transactions
   - Maximum donation limits: 20 average monthly salaries for individuals, 200 for legal entities
   - Source: Art. 22-23, Law on Financing Political Activities
   - Reference: <https://www.acas.rs/zakoni-i-drugi-propisi/zakoni/o-finansiranju-politickih-aktivnosti>

2. **MediaRepresentationInvariant**
   - Public media service must provide equal free time to all electoral lists
   - 48-hour electoral silence period before voting
   - Source: Art. 47-50, Law on Electronic Media
   - Reference: <https://www.rem.rs/uploads/files/Zakoni/Zakon-o-elektronskim-medijima.pdf>

## Real-World Implementation References

### Electoral Commission Operations

- **Composition of RIK**: 17 standing members + secretary + additional representatives
  - Source: <https://www.rik.parlament.gov.rs/tekst/sr/23/o-komisiji.php>
- **Electronic Voting Pilot Program**: Tested in 2023 local elections in Novi Beograd
  - Source: <http://mduls.gov.rs/saopstenja/elektronsko-glasanje-na-lokalnim-izborima-u-beogradu/>
- **Minority List Status**: Determined by RIK based on party statute and program
  - Source: Art. 137-138, Law on Election of MPs
  - Reference: <https://www.paragraf.rs/propisi/zakon_o_izboru_narodnih_poslanika.html>

### Voting Procedures

- **Mobile Voting**: Available for disabled/elderly voters upon request
  - Must be requested by 11AM on election day
  - Mobile team visits homes with portable ballot box
  - Source: Art. 72-73, Law on Election of MPs
  - Reference: <https://www.rik.parlament.gov.rs/tekst/sr/35/glasanje-van-birackog-mesta.php>

- **UV Lamp and Spray Application**:
  - Specific procedure introduced to prevent multiple voting
  - UV-reactive spray applied to voter's right index finger
  - Source: OSCE ODIHR Election Observation Mission Final Report, 2022
  - Reference: <https://www.osce.org/files/f/documents/6/8/530816.pdf> (p.22)

- **Voting in Prison Facilities**:
  - Special polling stations established in detention facilities
  - Only for prisoners who haven't lost voting rights through court decision
  - Source: Art. 57, Law on Election of MPs
  - Reference: <https://www.paragraf.rs/propisi/zakon_o_izboru_narodnih_poslanika.html>

### Local Community Elections (Mesne Zajednice)

- **Procedure in Belgrade Municipalities**:
  - Direct secret ballot with majority system
  - Candidates require 30 supporting signatures from local community
  - Source: Decision on Local Communities of City Municipality Vračar (2019)
  - Reference: <https://www.vracar.rs/eksterno/mesne-zajednice/>

### Recent Electoral Reform Implementation

- **2022 Reform Package**:
  - Implemented based on inter-party dialogue facilitated by EU
  - 3% threshold, improved transparency, extended deadlines for complaints
  - Source: Venice Commission Opinion CDL-AD(2022)002
  - Reference: <https://www.venice.coe.int/webforms/documents/?pdf=CDL-AD(2022)002-e>

## Event Storming Command-Policy-Event Chains

### Voter Registration Process

```
Command: CitizenTurns18
Aggregate: VoterRegistry
Event: NewVoterAdded
Policy: AutomaticVoterRegistration -> Updates central database
```

### Election Scheduling

```txt
Command: PresidentSchedulesElection
Aggregate: ElectionSchedule
Event: ElectionsScheduled
Policy: DistributeFormalNotice -> Triggers RIK preparations
```

### Candidate Registration

```txt
Command: SubmitElectoralList
Aggregate: ElectoralListApplication
Event: ListSubmissionReceived
Policy: ValidateSubmissionCompleteness -> Checks all requirements
Event: ListCorrectionRequested or ListApproved
Policy: If ListApproved -> AssignListNumber
```

### Election Day Operations

```txt
Command: OpenPollingStation
Aggregate: PollingStation
Event: PollingStationOpened
Policy: MonitorVoterTurnout -> Tracks participation
```

```txt
Command: ProcessVoter
Aggregate: VotingRecord
Event: BallotIssued
Policy: PreventDoubleVoting -> Checks UV mark and applies spray
```

```txt
Command: ClosePollingStation
Aggregate: PollingStation
Event: PollingStationClosed
Policy: InitiateVoteCounting -> Begins result calculation
```

### Result Determination

```txt
Command: CountBallots
Aggregate: VoteCount
Event: VotesCounted
Policy: RecordResultsInProtocol -> Documents official results
```

```txt
Command: SubmitPollingStationResults
Aggregate: ElectionResults
Event: PollingStationResultsReceived
Policy: AggregateResults -> Combines results at municipal level
```

```txt
Command: DetermineNationalResults
Aggregate: NationalResults
Event: PreliminaryResultsAnnounced
Policy: HandleComplaints -> Processes any objections
Event: FinalResultsConfirmed
Policy: AllocateMandates -> Applies D'Hondt method
```

```txt
Command: IssueMandateConfirmation
Aggregate: ElectedRepresentative
Event: MandateConfirmed
Policy: InitiateParliamentaryConstitution -> Begins first session
```

