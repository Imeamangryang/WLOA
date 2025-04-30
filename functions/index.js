const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {onCall} = require("firebase-functions/v2/https");
const functions = require("firebase-functions");

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

exports.getRandomReviewsV2 = onCall(async (req) => {
  const collectionName = req.data.collectionName;
  const numberOfReviews = parseInt(req.data.count || "5", 10);

  if (!collectionName) {
    throw new functions.https.HttpsError("invalid-argument", "Missing 'collectionName'");
  }

  try {
    const snapshot = await db.collection(collectionName).get();
    const allReviews = snapshot.docs.map((doc) => ({id: doc.id, ...doc.data()}));

    if (allReviews.length === 0) {
      return []; // 리뷰가 없으면 빈 배열 반환
    }

    // 무작위로 리뷰 선택
    const shuffledReviews = allReviews.sort(() => 0.5 - Math.random());
    const selectedReviews = shuffledReviews.slice(0, numberOfReviews);

    return selectedReviews;
  } catch (error) {
    throw new functions.https.HttpsError("internal", "리뷰를 가져오는 데 실패했습니다.", error);
  }
});
