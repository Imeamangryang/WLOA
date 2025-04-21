const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {onRequest} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const cors = require("cors")({origin: true}); // ⭐ CORS 설정

initializeApp();
const db = getFirestore();

const jobCollections = [
  "warlord", "berserker", "destroyer", "paladin", "slayer",
  "battlemaster", "infighter", "soulmaster", "lancer", "striker", "breaker",
  "blaster", "hawkeye", "scouter", "devilhunter", "gunslinger",
  "summoner", "sorceress", "arcana", "bard",
  "blade", "reaper", "souleater", "demonic", "weatherer",
  "artist", "wildsoul",
];

// 각 직업에 대해 트리거 등록
for (const alias of jobCollections) {
  exports[`updateAverageScore_${alias}`] = onDocumentWritten(
    {
      document: `${alias}/{documentId}`,
      region: "asia-northeast3",
      memory: "256MiB",
    },
    async () => {
      await updateAverageForJob(alias);
    },
  );
}

/**
 * 특정 직업 컬렉션의 subclass 평균 점수를 계산하고 average_scores에 저장합니다.
 * @param {string} collectionName - 영문 직업 컬렉션 이름
 */
async function updateAverageForJob(collectionName) {
  try {
    const querySnapshot = await db.collection(collectionName).get();
    const subclassScores = {};

    querySnapshot.forEach((doc) => {
      const data = doc.data();
      if (data.subclass && typeof data.score === "number") {
        if (!subclassScores[data.subclass]) {
          subclassScores[data.subclass] = [];
        }
        subclassScores[data.subclass].push(data.score);
      } else {
        console.warn(`문서 ID ${doc.id}에 유효한 "subclass" 또는 "score" 필드가 없습니다.`);
      }
    });

    const subclassStats = {};
    for (const subclass in subclassScores) {
      if (Object.prototype.hasOwnProperty.call(subclassScores, subclass)) {
        const scores = subclassScores[subclass];
        const average =
          scores.reduce((sum, score) => sum + score, 0) / scores.length;
        subclassStats[subclass] = {average, count: scores.length};
      }
    }

    const avgRef = db.collection("average_scores").doc(collectionName);
    const prevDoc = await avgRef.get();
    const previousData = prevDoc.exists ? prevDoc.data().subclassAverages : null;

    let isDifferent = true;
    if (previousData) {
      isDifferent = JSON.stringify(previousData) !== JSON.stringify(subclassStats);
    }

    if (isDifferent) {
      await avgRef.set({
        subclassAverages: subclassStats,
        updatedAt: FieldValue.serverTimestamp(),
      });
      console.log(`[${collectionName}] 평균 점수 업데이트 완료:`, subclassStats);
    } else {
      console.log(`[${collectionName}] 평균 점수에 변화가 없어 업데이트 생략`);
    }
  } catch (error) {
    console.error(`[${collectionName}] 평균 점수 업데이트 중 오류 발생:`, error);
  }
}

// ⭐ CORS 처리된 getRandomReviewsV2 함수
exports.getRandomReviewsV2 = onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const collectionName = req.query.collectionName;
      const numberOfReviews = parseInt(req.query.count || "5", 10);

      if (!collectionName) {
        res.status(400).send("Missing 'collectionName' query parameter.");
        return;
      }

      const snapshot = await db.collection(collectionName).get();
      const allReviews = snapshot.docs.map((doc) => ({id: doc.id, ...doc.data()}));

      if (allReviews.length === 0) {
        res.status(200).json([]);
        return;
      }

      const shuffledReviews = allReviews.sort(() => 0.5 - Math.random());
      const selectedReviews = shuffledReviews.slice(0, numberOfReviews);

      res.status(200).json(selectedReviews);
    } catch (error) {
      console.error("리뷰를 가져오는 중 오류 발생:", error);
      res.status(500).send("리뷰를 가져오는 데 실패했습니다.");
    }
  });
});
