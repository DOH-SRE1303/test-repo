#HELP #WAHEALTH
[[Paul Unsworth]] [[Cody Carmichael]]
[[GitHub Migration Log]]

Skyler's notes:
- Few dates on PowerPoint, so its hard to get chrono context. What's done? What's a work in progress?
	- JAN 8TH powerpoint is most recent info
	- Cody building JS product for WA HEALTH; previously R and Python product
	- This product needs better documentation
	- Paul believes Cody was really close to having a working prototype for helping decision making; thinks its a good time to discuss this
		- Can Jorge and I figure this out? Paul thinks we need 4 days
- You might consider an ArcGIS dashboard for this project. It allows you to host it on our ArcGIS Enterprise, would be simpler to maintain (not require app/web dev programming skills), and you could still utilize the same data, make tables, etc.
	- Data will likely need to be stored in an Azure Storage account or Agency GeoHUB storage
	- Scripts should get moved to GitHub and either used locally to refresh data or scheduled to run in Azure Dev Ops Pipelines.
	- https://hazards.fema.gov/nri/map#

## CHARS_PrevData
## Facility_Loc_Project
- What is this for?
- How is it relevant to HELP?
	- **Not HELP specific**
	- Type of thing they'd like to be able to do in the future
- This appears to be some kind of prototype. Perhaps for identifying facilities within a geographic context of HELP data?
## HELP for Exercise Team 12-20
- simple example that launches in web browser
- [ ] Which version of the code did this come from? Consider adding a version number to future exports and deployments
- older model
## HELP Simulator
- Has R and Python code, but not clear what's completed and unfinished at a glance
- Documentation is empty
- Python app
## HELP_Recent
- Another example that launches in the browser
- not clear if this one is more up to date than HELP for Exercise Team 12-20
- probably most up to date
## HELP_Show_Paul
- [ ] Cody rebuilt modules in JS?
- [ ] Not sure what he was using to produce these items, but I do not have the knowledge or skills to continue working on these
- [ ] Cody may have made this move to JS to make it more sustainable for future maintainers; person to talk to about maintainership is Andrew Lau
	- Some drama?
	- WA HEALTH Did not hire to replace Cody's skillset, hired for fit on the team
	- Working on a project for someone else
	- Share Drive files are gone?
	- This project require WA HEALTH team's help
		- Maybe broadening team in December
## HELP_Sim_Sources
- [ ] This folder has two CSV files and two JS files. Is this relevant to the HELP Simulator?
## HELP_v1_0
- Example that launches in browser for V1
- help v2 needs staffing data prior to v2 completion; Cody built simulator in advance
## HELP_v2_Simulator
- Does not contain a demo
- R and python code
- Python app
## MapImages
- Contains a map viewer of images from RHINO trajectories?
- **separate project from HELP**; Nate wanted vis of RHINO data over time
## PowerPoints
## HELP_RScripts
- Are these the original scripts that feed tableau dashboard?

Currently based on CHARS data only
Simulation tool is for estimating impacts of certain activities (WIP)

## Most Recent Presentation

![[Pasted image 20240805073723.png]]

![[Pasted image 20240805073804.png]]

![[Pasted image 20240805073830.png]]
^ more recent information
![[January_8_2024_Presentation.pptx]]

Conversational interaction?!
- AI piece
	- interpreting data requires an SME
	- what happens if/when Paul is gone?
Data integration pending data sources?
- play with other data sets at state level
- creating a CHARS baseline that can be used to compare to WA HEALTH, RHINO, etc.
	- ESSENCE groupings designed to interact with HELP
- ILERS
- Look at historic data in chars vs current intake coming from RHINO, staffing plans, ILERS for FTE employed to satisfy
- Paul has RCW on this; review and add to RCW list for data sharing
Multi-modal prediction and forecasting
Python application? Python conversion?
- this may be complete?
- Cody is developing with something else besides python now
"Easily integrate additional data from a wide variety of sources"?
- calculations across cells with input information
What happened after next steps after Slides for Viz PPT?

![[Pasted image 20240805074602.png]]
![[Slides for Viz.pptx]]
^ Earlier presentation, not where HELP is at this point

## Additional context from Paul
![[The Role of the HELP tool in survaillence and incident response.docx]]






