const protoo = require("protoo-server");
const mediasoup = require("mediasoup");
const https = require("http");
const axios = require('axios');
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

  //CPU core 갯수에 맞게 워커 생성
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
    // 스트리머 또는 시청자가 요청하는 url
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

          // protoo webSocket에 접속
          const protooWebSocketTransport = accept();

          // 일단 역할을 요청 url에 넣어둠
          const consume = role === "produce" ? false : true;

          room.handleProtooConnection({
            peerId,
            consume,
            protooWebSocketTransport,
          });

        })
        .catch((error) => {
          reject(error);
        });
  });
}

function getMediasoupWorker() {
  // 워커에 라우터 생성할때 라우터 갯수가 가장 적은 워커 사용 로직
  let minWorker = mediasoupWorkerCnt.sort(function(a,b) {
    return a["cnt"] - b["cnt"];
  })[0];

  const worker = mediasoupWorkers.get(minWorker["num"]);
  minWorker["cnt"]++;

  return [worker,minWorker["num"]];
}

async function CreateRoom({ roomId }) {
  let room = rooms.get(roomId);
  const [mediasoupWorker,workerNum] = getMediasoupWorker();
  // 만약 방이 없다면 방을 새로 생성
  if (!room) {
    console.log("룸생성 시작");
    roomCnt.set(roomId,1);

    try {
      room = await Room.create({ mediasoupWorker, roomId, workerNum});
    } catch (error) {
      console.log(error.message);
    };

    rooms.set(roomId, room);
    roomCnt.set(roomId,roomCnt.get(roomId)+1);
    // 스트리머가 방 종료시 요청을 받음
    room.on("close", () => {
      // 각 워커중에 라우터 갯수가 같은걸 찾아 지우기
      const minWorker = mediasoupWorkerCnt.find((obj) => {
        return obj["num"] === workerNum;
      });
      minWorker["cnt"]--;
      roomCnt.set(roomId,roomCnt.get(roomId)-1);
      rooms.delete(roomId);
    });
    // 시청자가 나가면 요청을 받음
    room.on("consumerClose",() => {
      roomCnt.set(roomId,roomCnt.get(roomId)-1);
    })
  }
  //만약 방 인원이 230명이 넘는다면, 새로운 라우터 생성후 기존 라우터와 연결
  else if(room && roomCnt.get(roomId) >= 1) {
    let roomId = `${roomId}1`;
    axios.put (`https://dev.streaminggate.shop/room-service/room`, {
      Headers: {
        'Content-Type' : 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      },
      data: {
        uuid: this._roomId
      }
    }).then((response) => {
      console.log("룸 정보 수정 성공")
    })
    const producerId = room._producerId;
    let connectRoom = await Room.create({mediasoupWorker,roomId });

    await room._mediasoupRouter.pipeToRouter({producerId: producerId,router: connectRoom._mediasoupRouter});

    rooms.set(roomId,connectRoom);

    roomCnt.set(roomId,roomCnt.get(roomId)+1);
  }

  return room;
}