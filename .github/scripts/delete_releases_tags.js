const axios = require('axios');

const personalAccessToken = process.env.PERSONAL_ACCESS_TOKEN;
const repo = process.env.GITHUB_REPOSITORY;

const [owner, repoName] = repo.split('/');

const axiosInstance = axios.create({
  baseURL: `https://api.github.com/repos/${owner}/${repoName}`,
  headers: {
    'Authorization': `token ${personalAccessToken}`,
    'Accept': 'application/vnd.github.v3+json',
  }
});

async function deleteReleases() {
  try {
    const releases = await axiosInstance.get('/releases');
    for (const release of releases.data) {
      console.log(`Deleting release: ${release.tag_name}`);
      await axiosInstance.delete(`/releases/${release.id}`);
    }
  } catch (error) {
    console.error(`Failed to delete releases: ${error.message}`);
  }
}

async function deleteDrafts() {
  try {
    const drafts = await axiosInstance.get('/releases', {
      params: {
        per_page: 100,  // Adjust this number if you have more drafts
        page: 1,
        draft: true
      }
    });
    for (const draft of drafts.data) {
      console.log(`Deleting draft: ${draft.tag_name}`);
      await axiosInstance.delete(`/releases/${draft.id}`);
    }
  } catch (error) {
    console.error(`Failed to delete drafts: ${error.message}`);
  }
}

async function deleteTags() {
  try {
    const tags = await axiosInstance.get('/tags');
    for (const tag of tags.data) {
      console.log(`Deleting tag: ${tag.name}`);
      await axiosInstance.delete(`/git/refs/tags/${tag.name}`);
    }
  } catch (error) {
    console.error(`Failed to delete tags: ${error.message}`);
  }
}

async function run() {
  await deleteDrafts();
  await deleteReleases();
  await deleteTags();
}

run();
