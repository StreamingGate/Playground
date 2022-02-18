const protoo = require("protoo-server");
const mediasoup = require("mediasoup");
const https = require("http");
const express = require("express");
const url = require("url");
const os = require("os");
const fs = require("fs");
const Room = require("./Room");
const config = require("./config");
const { AwaitQueue } = require("awaitqueue");
const rooms = new Map();
const roomCnt = new Map();
const queue = new AwaitQueue();
const mediasoupWorkerCnt = [];
const mediasoupWorkers = new Map();
run();

async function run() {
  await runMediasoupWorkers();
  await runHttpServer();
  await runProtooWebSocketServer();
}

async function runHttpServer() {
  expressApp = express();
  const tls =
      {
        cert : fs.readFileSync(config.https.tls.cert),
        key  : fs.readFileSync(config.https.tls.key)
      };
  httpsServer = https.createServer(expressApp);

  await new Promise((resolve) =>
  {
    httpsServer.listen(
        Number(config.https.listenPort), config.https.listenIp, resolve);
  });
}
async function runMediasoupWorkers() {
  const { numWorkers } = config.mediasoup;

  for (let i = 0; i < numWorkers; ++i) {
    const worker = await mediasoup.createWorker({
      rtcMinPort: Number(config.mediasoup.workerSettings.rtcMinPort),
      rtcMaxPort: Number(config.mediasoup.workerSettings.rtcMaxPort),
    });

    worker.on("died", () => {
      setTimeout(() => process.exit(1), 2000);
    });
    mediasoupWorkers.set(i, worker);
    mediasoupWorkerCnt.push({"num":i,"cnt":0});
  }
}

async function runProtooWebSocketServer() {
  console.log("running");

  protooWebSocketServer = new protoo.WebSocketServer(httpsServer, {
    maxReceivedFrameSize: 960000, // 960 KBytes.
    maxReceivedMessageSize: 960000,
    fragmentOutgoingMessages: true,
    fragmentationThreshold: 960000,
  });

  protooWebSocketServer.on("connectionrequest", (info, accept, reject) => {
    // The client indicates the roomId and peerId in the URL query.
    console.log("connect");
    const u = url.parse(info.request.url, true);
    const roomId = u.query["room"];
    const peerId = u.query["peer"];
    const role = u.query["role"];

    if (!roomId || !peerId) {
      reject(400, "Connection request without roomId and/or peerId");

      return;
    }


    queue
        .push(async () => {
          const room = await CreateRoom({roomId});
          // if(rooms.get(roomId) && roomCnt.get(roomId) > 320) {
          //   room = await getOrCreateRoom({roomId});
          // }
          // else {
          //   room = await CreateRoom({ roomId });
          // }

          // Accept the protoo WebSocket connection.
          const protooWebSocketTransport = accept();

          // 일단 역할을 요청 url에 넣어둠
          const consume = role === "produce" ? false : true;

          room.handleProtooConnection({
            peerId,
            consume,
            protooWebSocketTransport,
          });
          console.log("방생성후 완료~~~~")
        })
        .catch((error) => {
          reject(error);
        });
  });
}

function getMediasoupWorker() {

  let minWorker = mediasoupWorkerCnt.sort(function(a,b) {
    return a["cnt"] - b["cnt"];
  })[0];

  const worker = mediasoupWorkers.get(minWorker["num"]);
  minWorker["cnt"]++;

  return [worker,minWorker["num"]];
}

async function CreateRoom({ roomId }) {
  let room = rooms.get(roomId);

  // If the Room does not exist create a new one.
  if (!room) {
    console.log("룸생성 시작");

    const [mediasoupWorker,workerNum] = getMediasoupWorker();

    try {
      room = await Room.create({ mediasoupWorker, roomId, workerNum });
    } catch (error) {
      console.log(error.message);
    }
    rooms.set(roomId, room);

    // event emitter 상속후 가능
    room.on("close", () => {
      console.log("룸이 클로즈 됐습니다. 제발 여기 걸려라")

      const minWorker = mediasoupWorkerCnt.find((obj) => {
        return obj["num"] === workerNum;
      });
      minWorker["cnt"]--;
      rooms.delete(roomId);
    });
  }

  return room;
}

// async function getOrCreateRoom({roomId}) {
//   let room = rooms.get(roomId).getLast();
//   if(room && !room.hasPeer(peerId) && roomCnt.get(roomId) < 320) {
//     roomCnt.set(roomId,roomCnt.get(roomId)+1);
//     return room;
//   }
//   else if(room && roomCnt.get(roomId) > 320) {
//     const mediasoupWorker = getMediasoupWorker();
//     let connectRoom = await Room.create({room,mediasoupWorker,roomId});
//     rooms.get(roomId).push(connectRoom);
//     return connectRoom;
//   }
// }