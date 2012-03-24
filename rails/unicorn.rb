APP_PATH = "" #/home/adam/projects/gittest
APP_NAME = "" #gittest

if APP_PATH == ""
  puts "SET APP_PATH and APP_NAME FIRST!!"
  exit
end

working_directory APP_PATH

pid "#{APP_PATH}/tmp/pids/unicorn.pid"
stderr_path "#{APP_PATH}/log/unicorn.log"
stdout_path "#{APP_PATH}/log/unicorn.log"

listen "/tmp/unicorn.#{APP_NAME}.sock"
worker_processes 2
timeout 30
