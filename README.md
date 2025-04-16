# NYC Motor Vehicle Collision Analysis 🚗📊

This project analyzes over 1.6 million motor vehicle collisions in New York City (2012–2023)[https://www.kaggle.com/code/lxy21495892/eda-new-york-motor-vehicle-collisions] to uncover patterns in location, time, vehicle involvement, causes, and severity — supporting data-driven safety planning.

---

## 🛠️ Tools & Tech Stack

- **PostgreSQL** – querying and data transformation
- **Python (Pandas, Seaborn, Matplotlib)** – EDA and visualization
- **Folium** – interactive geographic mapping
- **Jupyter Notebook** – end-to-end workflow
- **VS Code** – development environment

---

## 🧠 Key Insights

- **Brooklyn and Queens** had the highest volume of collisions.
- **Pedestrians accounted for over 50% of fatalities**, despite fewer total incidents.
- **Driver distraction** was the top cause (40%+ of all collisions).
- **Friday afternoons** were the most collision-heavy time slot.
- **Post-2020 collisions were fewer but more severe**, likely due to risky driving on emptier roads.

---

## 📊 Visual Highlights

- Borough-wise bar charts and casualty breakdowns
- Hourly and weekly collision heatmaps
- Fatality rates per victim type
- Folium-based collision density map (interactive)

---

## 🧹 Cleaning & Challenges

- Normalized inconsistent vehicle types across 5 separate fields using SQL `CASE`
- Excluded ~35% of rows with missing boroughs (reverse-geocoding not feasible at scale)
- Unified date formatting for time-based aggregation

---

## 📬 Contact

**Author:** Saurav Singh  
📧 [ssaurav@hawk.iit.edu](mailto:ssaurav@hawk.iit.edu)  
🔗 [LinkedIn](https://www.linkedin.com/in/thesauravsingh)

---

