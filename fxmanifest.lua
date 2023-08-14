fx_version "cerulean"

games { "gta5" }

author "RK Studios"

server_scripts {
    "server.lua"
}

client_scripts {
    "vehicles.lua",
    "client.lua"
}

dependencies {
    "/server:5181",
    "qb-target"
}

escrow_ignore {
    "vehicles.lua"
}

lua54 "yes"