# R-projects
This repository contains all my projects implemented in R, showcasing data analysis, statistical modeling, and practical applications.

# R-SHINY DASHBOARD 
BACKGROUND OF THE PROJECT 
Sustainability, defined as "Development that meets the needs of the present generation without compromising the ability of Future Generations to meet their own needs" (United Nations General Assembly, 1987, p.43), is a current Global concern. The 17 Sustainable Development Goals were developed for the effective measurement of Sustainability across different dimensions. This report will primarily focus on one Sustainable Development Goal, 11— Sustainable Cities and Communities, in the context of India due to the relevance of the Goal in the Indian as well as Global context.

# DATA AND VARIABLES
For the purpose of the aforementioned analysis, the following two Datasets have been sourced: 
1. United Nations Statistics Dataset: Specifically downloaded for Goal 11, Indicator 11.1.1, which refers to the percentage of Urban Population Living in Slums. This dataset allows a cross-country comparison for this indicator. The variables from this Dataset, named "GeoAreaName" (Country Name), "Value" (% of Urban Population Living in Slums), and "Location" (Urban or City Classification), have been chosen for classification. The Data does not require much cleaning; however, the venue for the Country "Israel" has been manually removed from the Excel Sheet as it was an Outlier. The filtering for this Dataset has been done within R itself. 
2. NITI Aayog Sustainability Dataset: This Dataset allows comparison across different States of India, using localized indicators adapted through the National Indicator Framework of India (NIF). 

# ANALYSIS AND DISCUSSION 

## QUESTION 1: What is the Position of India with respect to other Countries for Indicator 11.1.1? Which Countries have performances comparable to India? 
ANSWER 1 
It is apparent that Greece has the highest value of urban population living in slums, which constitutes a total of 40.5% of the Urban population. To compare the position of India with other countries, a table and summary of the data were generated. The table shows the values that fall within the 1% greater or lesser range with respect to India. The countries Estonia, Finland, Latvia and Romania have performances comparable to India. Surprisingly, a highly developed country like Finland is also comparable to India in the context of indicator 11.1.1. From the summary, it is apparent that India falls in the second quartile with a value of 5.41%, and well below the median value, which is 8.20%. From the tables it might be concluded that, despite the differences in income between the countries mentioned in the table, India is performing fairly and has a reasonable proportion of the Urban Population living in slums. (Note: A slicer for countries has been added for the graph in the dashboard) 

## QUESTION 2: What is the Score for India based on the localized Indicators? How different is the Score Position from India's Position on the Global Index? 
ANSWER 2 
A normalized score has been derived for every state of India and has been aggregated in the form of an average to arrive at a composite score for the entire goal 11, based on the Niti Aayog data for localized indicators derived from the National Indicator Framework (NIF). A thorough descriptive analysis has been conducted on these normalized scores. From the dashboard it can be seen that the median score is 56.30, and the minimum and maximum scores are 5.64 and 75.75, respectively. The high range between the minimum and maximum value indicates that certain states are performing very well, and some have very poor performance for the goal. However, as per the data in the table, fifty per cent of the scores lie between the interquartile range of 41.22 and 60.82, which suggests a certain degree of uniformity between the scores. Another observation is the mean value being smaller than the median value, which shows a skewness towards lower values, suggesting poor sustainability in cities and communities. The pie chart drawn for India (on the left), along with a line graph sourced from the UN SDG Dashboard- 2024 (on the right), with respect to its SDG India Index score for goal 11, shows an average score of 47.9. This shows that in the context of Goal 11, India is halfway through and has progressed approximately 47.9% towards the Goal. However, this score, coupled with the scores of other SDGs, gives a slightly more enhanced score, leaning towards 62.28. This indicates a better score in other goals as compared to goal 11. 

## QUESTION 3: Which aspect of Goal 11 from the localized Indicators has the worst scores? 
ANSWER 3 
The analysis of which indicators have the poorest scores is of monumental significance, as it would tell the government which schemes to formulate and which policies to fund on a larger scale. Moreover, it would also create awareness amongst the public on which aspect of sustainability the citizens should work more on. In the context of Goal 11, a descriptive analysis was conducted on the values of all the indicators in order to gauge which areas need to be worked on the most. For this purpose, two graphs were generated. The first graph shows a comparison between different states based on the value of a certain indicator, and the second graph shows a specific table for the descriptive analysis of a particular indicator. For the former graph, separate slicers have been created for the state name and the variables. Similarly, for the latter graph, a slicer is available to change the variable name and state. On observing both the aforementioned graphs it can be inferred that: 
• The variable “Installed sewage treatment capacity to sewage generated in urban areas percentage (%)” has a high frequency of scores equal to 0%, which indicates the lack of sewage treatment in some areas. 
• The variable “Municipal solid waste (MSW) Processed to total MSW generated SBM (U) (%)” has value close to 0 in certain regions. which indicates that waste processing is nearly absent in certain parts of the country. 
• The “Wards with 100% door-to-door waste collection (SBM(U)) (%)” Has a critically low value in some regions, which indicates poor waste collection coverage in Indian states. 
• In addition to this, the variable “Urban households living in Katcha houses (%)” has a high value for certain states (for example, Andhra Pradesh), which indicates poor housing conditions. 

## QUESTION 4: What are the Positions of the different States of India with respect to Goal 11 based on the localized Indicators? Which States have better Performance? 
ANSWER 4 
A normalized score out of 100 was calculated using the following formula for the states of India in the context of SDG 11, based on the localised indicators. Based on the graph generated for the normalized scores, the following inferences can be made: 
• Best performing states: Have the highest scores include Chandigarh (75.75), Himachal Pradesh (75.54.), Punjab and Gujarat. The higher scores of Chandigarh might be owing to the fact that it is a planned city with urban infrastructure, waste management and sustainable housing policies. Contrary to this, the high score of Himachal Pradesh might be owing to low pollution levels, effective resource management, and sustainable urban planning in key towns. States like Maharashtra, Madhya Pradesh and Odisha have higher scores as well (in the 60s) but still remain in the medium range, which indicates scope for improvement. 
• Worst performing states: The worst scores in the index were obtained by Lakshadweep (5.64), Nagaland (23.02), Meghalaya (27.13), and West Bengal (24.53). The poor scores of Lakshadweep, Nagaland and Meghalaya might be attributed to lack of access to basic urban services, whereas the low scores of West Bengal might be attributed to urban congestion and lack of affordable housing.

## QUESTION 5: Does the effect of Schemes like PMAY have a role in the Scores of the States for Goal 11? 
ANSWER 5 
The Indian government launched the Pradhan Mantri Awas Yojana-U (PMAY-U) in 2015 as a flagship initiative under SDG Goal 11: Sustainable Cities and Communities. It aims to provide "Housing for All," especially for the economically disadvantaged (EWS), low-income groups (LIG), and middle-income groups (MIG), by ensuring affordable and sustainable urban housing. To assess the impact of the Pradhan Mantri Awas Yojana Urban Sector (PMAY-U) government scheme, a simple linear model correlation was performed between the two variables: Houses for which construction is complete under Pradhan Mantri Awas Yojna (U), and the Proportion of Urban Population living in Katcha house (%). A trendline was added to the graph to assess the slope between the two variables. The scatter plot generated can be seen in the dashboard, where each dot represents a state. As it can be observed from the graph, there is negligible correlation between the two variables, suggesting that the Pradhan Mantri Awas Yojana scheme barely affects the proportion of the urban population living in Katcha House; on computation, the correlation comes out to be 0.01, which is negligible. This suggests that other factors like government priorities, funding, and rural-urban distribution might explain the housing allocations under the scheme. Moreover, this lack of correlation might also suggest gaps in the scheme implementation. 

# CONCLUSION 
The progress in the context of SDG Goal 11: Sustainable Cities and Communities has been extremely unequal among states in India. Increased normalized scores among states like Chandigarh, Himachal Pradesh, Gujarat, and Punjab suggest that programs of urban sustainability have been implemented more effectively within these states due to enhanced infrastructure, efficient city planning, and good governance. On the other hand, lower ranks of states such as Lakshadweep, Nagaland, Meghalaya, and West Bengal are indicative of housing, urban infrastructure, and policy implementation issues. Although PMAY-U (Pradhan Mantri Awas Yojana - Urban) has been initiated as a significant policy for addressing urban housing requirements, its tangible contribution towards overall urban sustainability is doubtful. The differences observed between states give rise to the potential that forces independent of PMAY-U, including governance, infrastructure development, and policy enforcement, are playing a more significant role. Further study is necessary in order to determine if PMAY-U has contributed with measurable effect towards Goal 11 or if its influence only pertains to housing-specific aspects. 

# REFERENCES 
Appsilon. (n.d.). Tutorial: Create and customize a simple R Shiny dashboard [Video]. YouTube. Retrieved March https://www.youtube.com/watch?v=41jmGq7ALMY

FreeCodeCamp.org. (n.d.). R Shiny for data science tutorial – Build interactive data-driven web YouTube. Retrieved https://www.youtube.com/watch?v=9uFQECk30kA March 15, 2025.

National Data & Analytics Platform (NDAP), NITI Aayog. (n.d.). Dataset 7365. Government of India. Retrieved March 15, 2025, from https://ndap.niti.gov.in/dataset/7365

NITI Aayog. (2019). SDG mapping document (p. 34). Government of India. Retrieved from https://www.niti.gov.in/sites/default/files/2019-01/SDGMapping-Document-NITI_0.pdf

Observer Research Foundation (ORF). (n.d.). Sustainable Development Goal 11 and India. Retrieved March 15, 2025, from https://www.orfonline.org/expert-speak/sustainable development-goal-11-and-india

SivaKV2. (n.d.). EPGDA2_InteractiveApps2 [GitHub repository]. GitHub. Retrieved March 15, 2025, from https://github.com/sivakv2/EPGDA2_InteractiveApps2

United Nations General Assembly. (1987). Report of the World Commission on Environment and Development: Our common future (A/42/427, p. 43). United Nations. Retrieved from https://sustainabledevelopment.un.org/content/documents/5987our-common-future.pdf

United Nations Statistics Division. (n.d.). Sustainable Development Goals Data Portal. United Nations. Retrieved March 15, 2025, from https://unstats.un.org/sdgs/dataportal/database



