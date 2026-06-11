const cpuHistory = [];

const ctx = document.getElementById("chart");

const chart = new Chart(ctx,{
    type:"line",
    data:{
        labels:[],
        datasets:[{
            label:"CPU %",
            data:[]
        }]
    }
});

async function update(){
    const res = await fetch("/api/stats");
    const data = await res.json();

    document.getElementById("cpu").innerText =
        data.cpu + "%";

    document.getElementById("ram").innerText =
        `${data.ram}% (${data.ram_used}/${data.ram_total} GB)`;

    document.getElementById("disk").innerText =
        `${data.disk_percent}%`;

    document.getElementById("time").innerText =
        data.time;

    chart.data.labels.push("");
    chart.data.datasets[0].data.push(data.cpu);

    if(chart.data.labels.length > 30){
        chart.data.labels.shift();
        chart.data.datasets[0].data.shift();
    }

    chart.update();

    const files = document.getElementById("files");
    files.innerHTML = "";

    data.files.forEach(f=>{
        const li = document.createElement("li");
        li.textContent = `${f.name} (${f.size} bytes)`;
        files.appendChild(li);
    });
}

setInterval(update,2000);
update();
